import os
import unittest

from subprocess import Popen, PIPE

class TestInstallation(unittest.TestCase):

    cwd = os.getcwd()

    def test_git_template(self):
        self.assertTrue(os.path.isdir(os.path.join(self.cwd, '.git')),
                        '.git directory not found')
        self.assertTrue(os.path.isdir(os.path.join(self.cwd, '.git/hooks')),
                        '.git directory not found')
        self.assertTrue(os.path.isfile(os.path.join(self.cwd, '.git/hooks/commit-msg'))
    )


if __name__ == '__main__':
    unittest.main()
