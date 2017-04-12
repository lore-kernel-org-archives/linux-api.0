From: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [kernel-hardening] Re: [PATCH RFC v2 1/3] LSM: Allow per LSM
 module per "struct task_struct" blob.
Date: Wed, 12 Apr 2017 18:08:45 +0200
Message-ID: <CAEiveUd+5NkW6Sfx1VSHqYCBUuB9rM4bF0yPBQZZXGe=EFCz6A@mail.gmail.com>
References: <1491734530-25002-1-git-send-email-tixxdz@gmail.com>
 <1491734530-25002-2-git-send-email-tixxdz@gmail.com> <f25edeb6-35e1-2f8c-8fd6-fd051c4e79ce@schaufler-ca.com>
 <CAEiveUeHedQAsjbS5Jj9imq28af0OuKAjMTudMJm7GqObRNMfQ@mail.gmail.com>
 <2698e97b-397e-0fc0-84a1-dc9a4226117a@schaufler-ca.com> <CAEiveUd4Obc+YsCiO7dp3-jypbJ4vMmsBOU=Ax8yF7+6dLes0w@mail.gmail.com>
 <CAGXu5jL7jLid57UoXCxSqo5JZRLMgZ7X6BSYgWLckp5YpoiAmA@mail.gmail.com> <8551d1ff-2c6e-bf9b-5615-fbff089ef252@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8551d1ff-2c6e-bf9b-5615-fbff089ef252-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org" <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dongsu Park <dpark-VwIFZPTo/vqsTnJN9+BGXg@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 11, 2017 at 9:54 PM, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org> wrote:
> On 4/10/2017 9:43 PM, Kees Cook wrote:
>> On Mon, Apr 10, 2017 at 1:00 PM, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>> On Mon, Apr 10, 2017 at 9:26 PM, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org> wrote:
>>>> I think that would be the prudent approach. There is still
>>>> the possibility that blob sharing (or full stacking, if you
>>>> prefer) won't be accepted any time soon.
>>> Ok Casey! I will wait for more feedback, and if other maintainers do
>>> not object, I will convert it back to rhashtables in next iterations
>>> making sure that it should be simple to convert later to a blob
>>> sharing mechanism.
>> Would it be possible just to add a single field to task_struct if this
>> LSM is built in? I feel like rhashtables is a huge overhead when a
>> single field is all that's needed.
>
> Special casing the task_struct based on which modules
> are compiled in would work, but I'm under the impression
> that there's a strong desire to keep to one pointer for
> security module information in the major structures.
>
> The code for generalizing shared blobs isn't that hard,
> and y'all have seen it many times. It would be perfectly
> safe to convert the task, cred, inode and such blobs to
> be infrastructure managed right now. That wouldn't mean
> that all the stacking issues (e.g. audit and networking)
> would be addressed, or that all combinations of modules
> would work (i.e. no SELinux+Smack) but it would clear
> the way for this case. And Yama could use a blob if it
> wanted to.

I've been thinking about this again, so my patches did not convert
creds, inodes etc, I don't have a use case for them now. My use case
was for task->security and I re-used the simple approach. I can't
offer a solution for other blobs since I'm not familiar with their
context nor the different use cases. I checked TOMOYO and that was
easy, but I can't check all of them. I agreed that I may use
rhashtables but as Kees pointed out this may introduce overheads and
extra memory, where the task->security for this ModAutoProtect LSM
will only require an extra sizeof(unsigned long) per-task. Also again
the problem is not in this proposed Module, the problem is in modules
that can't be stacked together.

I am bringing this, since maybe after we manage to merge this, and if
Kees agree I may send another set of patches for Yama to enable the
same per-task context, this enables containers but also allows later
in systemd-logind sessions to set it where all inferiors inside the
user sessions are protected by default, not only some apps or special
desktops but for all. So I will hit the same problem again where to
put it? You said that the code that generalize the blobs isn't that
hard, but also in a previous response that it may not be accepted...
so I will try to converge the task->security blob to be more like the
infrastructure that you are proposing, then resubmit and maybe we will
enable these modules that are stackable by default.

Is this reasonable ?


Thanks!

-- 
tixxdz
