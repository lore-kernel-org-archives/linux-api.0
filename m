From: Bert Wesarg <bert.wesarg-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: [REVIEW][PATCH 0/4] /proc/thread-self
Date: Fri, 1 Aug 2014 09:14:45 +0200
Message-ID: <CAKPyHN1k80fc0hkg7agMkCMDsb623=Zf-TrpyMiMLvtYEjz3_Q@mail.gmail.com>
References: <87oaw5caq1.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87oaw5caq1.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Aug 1, 2014 at 2:30 AM, Eric W. Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>
> This patchset implements /proc/thread-self a magic symlink that
> solves a couple of problems.

shouldn't we keep the 'task' in the name, as it points into the 'task'
directory? And why not mimic the current 'self -> <id>' ideom under
/proc/<tgid>/task too and put a new 'self' link there:

$ ls -l /proc/self/task/self
  lrwxrwxrwx 1 root root 0 Aug  1 00:00 /proc/self/task/self -> 484

Bert
