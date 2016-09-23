From: Florian Weimer <fweimer@redhat.com>
Subject: Re: Naming O_TMPFILE files
Date: Fri, 23 Sep 2016 10:41:24 +0200
Message-ID: <2be4ffbb-abab-42c8-88a3-910230bf0d13@redhat.com>
References: <0831c636-4513-7c6c-255d-737a4415c8af@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------6623F96C75659B5AA4D9D444"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <0831c636-4513-7c6c-255d-737a4415c8af@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, aneesh.kumar@linux.vnet.ibm.com, Alexander Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

This is a multi-part message in MIME format.
--------------6623F96C75659B5AA4D9D444
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09/21/2016 01:50 PM, Florian Weimer wrote:
> AT_EMPTY_PATH is supposed to be able to give names to files created with
> O_TMPFILE unless O_EXCL was specified at creation time.
>
> However, since this commit
>
> commit 11a7b371b64ef39fc5fb1b6f2218eef7c4d035e3
> Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Date:   Sat Jan 29 18:43:42 2011 +0530
>
> fs: allow AT_EMPTY_PATH in linkat(), limit that to CAP_DAC_READ_SEARCH
>
> linkat bails out early with AT_EMPTY_PATH and !CAP_DAC_READ_SEARCH,
> never looking at O_EXCL.
>
> The /proc/self/fd kludge works for unprivileged users, but only if
> *both* paths use AT_FDCWD.  It fails if the first path uses a real
> descriptor for /proc/self/fd, or if the second path uses a real
> descriptor for the current directory, or both.  For privileged users,
> only AT_EMPTY_PATH case with an AT_FDCWD target works.
>
> The attached test program prints under a non-privileged user:
>
> error: linkat (fd, "", AT_FDCWD, out_name, AT_EMPTY_PATH):
>   No such file or directory
> error: linkat (fd, "", current_fd, out_name, AT_EMPTY_PATH):
>   No such file or directory
> success: linkat (AT_FDCWD, proc_name, AT_FDCWD, out_name,
> AT_SYMLINK_FOLLOW)
> error: linkat (AT_FDCWD, proc_name, current_fd, out_name,
> AT_SYMLINK_FOLLOW):
>   No such file or directory
> error: linkat (proc_fd, proc_name, AT_FDCWD, out_name, AT_SYMLINK_FOLLOW):
>   No such file or directory
> error: linkat (proc_fd, proc_name, current_fd, out_name,
> AT_SYMLINK_FOLLOW):
>   No such file or directory
> successes: 1, failures: 5
>
> And under a privileged user:
>
> success: linkat (fd, "", AT_FDCWD, out_name, AT_EMPTY_PATH)
> error: linkat (fd, "", current_fd, out_name, AT_EMPTY_PATH):
>   No such file or directory
> error: linkat (AT_FDCWD, proc_name, AT_FDCWD, out_name, AT_SYMLINK_FOLLOW):
>   No such file or directory
> error: linkat (AT_FDCWD, proc_name, current_fd, out_name,
> AT_SYMLINK_FOLLOW):
>   No such file or directory
> error: linkat (proc_fd, proc_name, AT_FDCWD, out_name, AT_SYMLINK_FOLLOW):
>   No such file or directory
> error: linkat (proc_fd, proc_name, current_fd, out_name,
> AT_SYMLINK_FOLLOW):
>   No such file or directory
> successes: 1, failures: 5
>
> (Seen on tmpfs and XFS, 4.7.x kernels.)
>
> I double-checked with strace, and the test case does not appear to be
> broken.  But the exhibited behavior is truly bizarre, and it means that
> it is very difficult to give a name to an O_TMPFILE file.

The test case is broken because it does not account for the fact that an 
O_TMPFILE file can only be linked once in this way.  This is still a bit 
counter-intuitive, but it means that O_TMPFILE works.

Florian


--------------6623F96C75659B5AA4D9D444
Content-Type: text/x-csrc;
 name="linkat.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="linkat.c"

#include <unistd.h>
#include <fcntl.h>
#include <err.h>
#include <stdio.h>

static int failures;
static int successes;

#define CHECK(ret)                              \
  do                                            \
    if ((ret) < 0)                              \
      {                                         \
        printf ("error: %s:\n  %m\n", #ret);    \
        ++failures;                             \
      }                                         \
    else                                        \
      {                                         \
        printf ("success: %s\n", #ret);         \
        ++successes;                            \
      }                                         \
  while (0)

static const char *const out_name = "linkat.out";

void
setup_fd (int *pfd)
{
  if (*pfd >= 0)
    close (*pfd);
  *pfd = open (".", O_RDWR | O_TMPFILE, 0);
  if (*pfd < 0)
    err (1, "open");
}

int
main (void)
{
  unlink (out_name);

  int current_fd = open (".", O_RDONLY | O_DIRECTORY);
  if (current_fd < 0)
    err (1, "open (O_DIRECTORY)");
  int proc_fd = open ("/proc/self/fd", O_RDONLY | O_DIRECTORY);
  if (proc_fd < 0)
    err (1, "open (O_DIRECTORY)");

  int fd = -1;
  setup_fd (&fd);
  CHECK (linkat (fd, "", AT_FDCWD, out_name, AT_EMPTY_PATH));
  unlink (out_name);
  setup_fd (&fd);
  CHECK (linkat (fd, "", current_fd, out_name, AT_EMPTY_PATH));
  unlink (out_name);

  char proc_name[100];
  snprintf (proc_name, sizeof (proc_name), "/proc/self/fd/%d", fd);

  setup_fd (&fd);
  CHECK (linkat (AT_FDCWD, proc_name, AT_FDCWD, out_name,
                 AT_SYMLINK_FOLLOW));
  unlink (out_name);
  setup_fd (&fd);
  CHECK (linkat (AT_FDCWD, proc_name, current_fd, out_name,
                 AT_SYMLINK_FOLLOW));
  unlink (out_name);

  snprintf (proc_name, sizeof (proc_name), "%d", fd);
  setup_fd (&fd);
  CHECK (linkat (proc_fd, proc_name, AT_FDCWD, out_name,
                 AT_SYMLINK_FOLLOW));
  unlink (out_name);
  setup_fd (&fd);
  CHECK (linkat (proc_fd, proc_name, current_fd, out_name,
                 AT_SYMLINK_FOLLOW));
  unlink (out_name);

  printf ("successes: %d, failures: %d\n", successes, failures);

  return 0;
}


--------------6623F96C75659B5AA4D9D444--
