import os
import unittest

from subprocess import Popen, PIPE


class TestInstallation(unittest.TestCase):

    home = os.path.expanduser('~')

    def test_git_template(self):
        self.assertTrue(os.path.isdir(os.path.join(self.home, '.git-templates')),
                        '.git-templates directory not found')
        self.assertTrue(os.path.isdir(os.path.join(self.home, '.git-templates/hooks')),
                        '.git-templates directory not found')
        self.assertIn('sailr.sh', os.readlink(os.path.join(self.home, '.git-templates/hooks/commit-msg')),
                      'git hook must point to sailr.sh')

    def test_git_config(self):
        process = Popen(['git', 'config', 'init.templatedir'], stdin=PIPE, stdout=PIPE, stderr=PIPE)
        output, err = process.communicate('')
        return_code = process.returncode
        self.assertEqual(output, b'~/.git-templates\n')
        self.assertEqual(err, b'')
        self.assertEqual(return_code, 0)


if __name__ == '__main__':
    unittest.main()
