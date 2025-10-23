import pytest

from container_ci_suite.openshift import OpenShiftAPI

from conftest import VARS


class TestRedisImagestreamTemplate:

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
    def test_redis_imagestream_template(self, template):
        os_name = ''.join(i for i in VARS.OS if not i.isdigit())
        assert self.oc_api.deploy_image_stream_template(
            imagestream_file=f"imagestreams/redis-{os_name}.json",
            template_file=f"examples/{template}",
            app_name=self.oc_api.pod_name_prefix
        )
        assert self.oc_api.is_pod_running(pod_name_prefix=self.oc_api.pod_name_prefix)
