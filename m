From: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/7] CLONE_FD: Task exit notification via file descriptor
Date: Mon, 15 Jun 2015 12:06:00 +0200
Message-ID: <557EA388.5090902@redhat.com>
References: <cover.1426376419.git.josh@joshtriplett.org> <556818A7.3030804@redhat.com> <1775865.3maNSqUW4u@tjmaciei-mobl4>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1775865.3maNSqUW4u@tjmaciei-mobl4>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thiago Macieira <thiago.macieira-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 05/29/2015 10:27 PM, Thiago Macieira wrote:

>> It has been suggested (e.g.,
>> <https://sourceware.org/bugzilla/show_bug.cgi?id=15661#c3>) that you can
>> use the existing clone(2) without specifying SIGCHLD to create a new
>> process.  The resulting child process is not supposed to show up in
>> wait(2), only in a waitpid(2) (or similar) explicitly specifying the
>> PID.  Is this not the case?
> 
> Hi Florian
> 
> That sounds orthogonal to what we're looking for. Our objective is to get 
> notification of when the child exited without resorting to SIGCHLD. If we use 
> the regular clone(2) without SIGCHLD and without CLONE_FD, we get no 
> notification. The only way to know of the child's termination is by a blocking 
> waitpid(2), like you indicated, which is counter productive to our needs.
> 
> We need something we can select(2)/poll(2) on.

Thanks for the clarification.  I agree that this is a separate and quite
sensible use case.

-- 
Florian Weimer / Red Hat Product Security
