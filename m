From: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 00/26] Fixing wait, exit, ptrace, exec, and CLONE_THREAD
Date: Wed, 7 Jun 2017 22:21:52 +1000
Message-ID: <6168b181-c57d-babb-e700-bdc30186a22a@suse.de>
References: <877f0pym71.fsf@xmission.com>
	<dd16b1bb-e99e-69f2-72f4-1be4cb24d18d@suse.de>
	<87ink8vxkf.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <87ink8vxkf.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 06/07/2017 09:36 PM, Eric W. Biederman wrote:
>>> Another easy entry point is to see that a multi-threaded setuid won't
>>> change the credentials on a zombie thread group leader.  Which can allow
>>> sending signals to a process that the credential change should forbid.
>>> This is in violation of posix and the semantics we attempt to enforce in
>>> linux.
>>
>> I might be completely wrong on this point (and I haven't looked at the patches),
>> but I was under the impression that multi-threaded set[ug]id was implemented in
>> userspace (by glibc's nptl(7) library that uses RT signals internally to get
>> each thread to update their credentials). And given that, I wouldn't be
>> surprised (as a user) that zombie threads will have stale credentials (glibc
>> isn't running in those threads anymore).
>>
>> Am I mistaken in that belief?
> 
> Would you be surprised if you learned that if your first thread
> exits, it will become a zombie and persist for the lifetime of your
> process?
> 
> Furthermore all non-thread specific signals will permission check
> against that first zombie thread.

Ah okay, so it really is a matter of Linux's threadgroup semantics just 
not being "right" on a more fundamental level than nptl.

> Which I think makes this surprising even if you know that setuid is
> implemented in userspace.

Quite surprising, thanks for the explanation.

-- 
Aleksa Sarai
Software Engineer (Containers)
SUSE Linux GmbH
https://www.cyphar.com/
