From: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCHv2 00/11] Adding FreeBSD's Capsicum security framework
Date: Tue, 29 Jul 2014 10:43:34 +0200
Message-ID: <53D75EB6.1090301@redhat.com>
References: <1406296033-32693-1-git-send-email-drysdale@google.com>	<871tt796i0.fsf@x220.int.ebiederm.org>	<CAHse=S_7Jpb9bTXHgU8q8_UZ=ce2gwdq8C15a+jbfO_pHmV_iA@mail.gmail.com> <87ha21qja0.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87ha21qja0.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Il 28/07/2014 23:13, Eric W. Biederman ha scritto:
> This notion that a shared structure should have different semantics
> depending on who is looking at it, sounds like a maintenance nightmare
> to me. 

Isn't that already with seccomp BPF filters?  You can have the parent
process set a BPF filter that forbids read on that file descriptor or
write on that file descriptor.

Effectively, this patchset provides the functionality to "hotplug" BPF
filters on a running process as more file descriptors are passed via
SCM_RIGHTS.  Except it doesn't use BPF filters, and instead uses a
separate set of discrete capabilities.

> I see two sensible implementations:
> - Add a seccomp bpf filter to struct file.

I proposed something like this, but it has some additional
implementation complications.  See the v1 thread.

But it does have to be in a file descriptor rather than a struct file.
It's part of the model that two processes can have different views of
the file descriptor (again my toy example is that of an eventfd that an
unprivileged child process can only write to).

> Additionally unless there is a process wide restriction to relative
> paths I can trivially escape your relative path implementation by simply
> doing open(.) and getting a struct file without any of those
> restrictions.

Yes, there is a prctl for that.

Paolo
