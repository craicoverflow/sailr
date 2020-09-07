import os
import unittest


class TestInstallation(unittest.TestCase):

    os.chdir(os.environ["HOME"])
    cwd = os.getcwd()

    def test_git_template(self):
        self.assertTrue(
            os.path.isdir(os.path.join(self.cwd, ".git-templates")),
            ".git directory not found",
        )
        self.assertTrue(
            os.path.isdir(os.path.join(self.cwd, ".git-templates/hooks")),
            ".git directory not found",
        )

        self.assertTrue(
            os.path.isfile(os.path.join(self.cwd, ".git-templates/hooks/commit-msg"))
        )


if __name__ == "__main__":
    unittest.main()
