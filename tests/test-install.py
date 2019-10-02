import os
import unittest


class TestInstallation(unittest.TestCase):

    home = os.path.expanduser('~')

    def test_git_template(self):
        self.assertTrue(os.path.isdir(os.path.join(self.home, '.git-templates')),
                        '.git-templates directory not found')
        self.assertTrue(os.path.isdir(os.path.join(self.home, '.git-templates/hooks')),
                        '.git-templates directory not found')
        self.assertIn('sailr.sh', os.readlink(os.path.join(self.home, '.git-templates/hooks/commit-msg')),
                      'git hook must point to sailr.sh')


if __name__ == '__main__':
    unittest.main()
