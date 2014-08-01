From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [REVIEW][PATCH 0/4] /proc/thread-self
Date: Fri, 01 Aug 2014 00:45:23 -0700
Message-ID: <871tt08xgs.fsf@x220.int.ebiederm.org>
References: <87oaw5caq1.fsf@x220.int.ebiederm.org>
	<CAKPyHN1k80fc0hkg7agMkCMDsb623=Zf-TrpyMiMLvtYEjz3_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <CAKPyHN1k80fc0hkg7agMkCMDsb623=Zf-TrpyMiMLvtYEjz3_Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Bert Wesarg's message of "Fri, 1 Aug 2014 09:14:45 +0200")
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Bert Wesarg <bert.wesarg-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Bert Wesarg <bert.wesarg-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org> writes:

> On Fri, Aug 1, 2014 at 2:30 AM, Eric W. Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>>
>> This patchset implements /proc/thread-self a magic symlink that
>> solves a couple of problems.
>
> shouldn't we keep the 'task' in the name, as it points into the 'task'
> directory? And why not mimic the current 'self -> <id>' ideom under
> /proc/<tgid>/task too and put a new 'self' link there:
>
> $ ls -l /proc/self/task/self
>   lrwxrwxrwx 1 root root 0 Aug  1 00:00 /proc/self/task/self -> 484

No particularly good reason.  

Mostly I picked thread-self as I could pick that out as a concept in the
code distinct from self and distinct from thread and it the
implementation was stratighforward.

Your approach requires a bit more symlink recursion than mine so it is
not my first choice.

I almost pointed it at just the sometimes invisible thread directory
directly under /proc so it would be a single number.  But that has the
issue that it you still get the process rollups in the numbers reported
by some of the proc files, which is undesirable.

Frankly I think it was a mistake by the nptl kernel code to have changed
the implementation of self.  But changing /proc/self to return the tid
at this point is more likely than not to beak applications so that I
have avoided.

Eric
