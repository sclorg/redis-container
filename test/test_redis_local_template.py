import pytest

from container_ci_suite.openshift import OpenShiftAPI

from conftest import VARS


class TestRedisDeployTemplate:

    def setup_method(self):
        self.oc_api = OpenShiftAPI(pod_name_prefix="redis", version=VARS.VERSION)

    def teardown_method(self):
        self.oc_api.delete_project()

    @pytest.mark.parametrize(
        "template",
        [
            "redis-ephemeral-template.json",
            "redis-persistent-template.json"
        ]
    )
    def test_redist_template_inside_cluster(self, template):
        assert self.oc_api.deploy_template_with_image(
            image_name=VARS.IMAGE_NAME,
            template=f"examples/{template}",
            name_in_template="redis",
            openshift_args=[
                f"REDIS_VERSION={VARS.VERSION}",
                f"DATABASE_SERVICE_NAME={self.oc_api.pod_name_prefix}",
                "REDIS_PASSWORD=testp"
            ]
        )

        assert self.oc_api.is_pod_running(pod_name_prefix=self.oc_api.pod_name_prefix)
        assert self.oc_api.check_command_internal(
            image_name=f"registry.redhat.io/{VARS.OS}/redis-{VARS.VERSION}",
            service_name=self.oc_api.pod_name_prefix,
            cmd="timeout 15 redis-cli -h <IP> -a testp ping",
            expected_output="PONG"
        )
