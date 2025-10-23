import pytest

from container_ci_suite.helm import HelmChartsAPI

from conftest import VARS


class TestHelmRHELRedisImageStreams:

    def setup_method(self):
        package_name = "redhat-redis-imagestreams"
        self.hc_api = HelmChartsAPI(
            path=VARS.TEST_DIR, package_name=package_name, tarball_dir=VARS.TEST_DIR
        )
        self.hc_api.clone_helm_chart_repo(
            repo_url="https://github.com/sclorg/helm-charts", repo_name="helm-charts",
            subdir="charts/redhat"
        )

    def teardown_method(self):
        self.hc_api.delete_project()

    @pytest.mark.parametrize(
        "version,registry,expected",
        [
            ("6-el8", "registry.redhat.io/rhel8/redis-6:latest", True),
            ("6-el9", "registry.redhat.io/rhel9/redis-6:latest", True),
            ("7-el9", "registry.redhat.io/rhel9/redis-7:latest", True),
            ("7-el8", "registry.redhat.io/rhel8/redis-7:latest", False),
        ],
    )
    def test_package_imagestream(self, version, registry, expected):
        assert self.hc_api.helm_package()
        assert self.hc_api.helm_installation()
        assert self.hc_api.check_imagestreams(version=version, registry=registry) == expected
