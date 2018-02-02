From: Paul Moore <paul@paul-moore.com>
Subject: Re: RFC(V3): Audit Kernel Container IDs
Date: Fri, 2 Feb 2018 17:05:22 -0500
Message-ID: <CAHC9VhQ5ciUZDhrsb6S4YxwuzQEY-ra2RTDceWXOdjHEBoZ0BQ@mail.gmail.com>
References: <20180109121620.wi7dq2423ugsraqv@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180109121620.wi7dq2423ugsraqv@madcap2.tricolour.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Guy Briggs <rgb@redhat.com>
Cc: cgroups@vger.kernel.org, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Linux Audit <linux-audit@redhat.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Linux Network Development <netdev@vger.kernel.org>, mszeredi@redhat.com, Andy Lutomirski <luto@kernel.org>, jlayton@redhat.com, Carlos O'Donell <carlos@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>, Simo Sorce <simo@redhat.com>, trondmy@primarydata.com, Eric Paris <eparis@parisplace.org>, "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 9, 2018 at 7:16 AM, Richard Guy Briggs <rgb@redhat.com> wrote:
> Containers are a userspace concept.  The kernel knows nothing of them.
>
> The Linux audit system needs a way to be able to track the container
> provenance of events and actions.  Audit needs the kernel's help to do
> this.

Two small comments below, but I tend to think we are at a point where
you can start cobbling together some prototype/RFC patches.  Surely
there are going to be a few changes, and new comments, that come out
once we see an initial implementation so let's see what those are.

> The registration is a u64 representing the audit container identifier
> written to a special file in a pseudo filesystem (proc, since PID tree
> already exists) representing a process that will become a parent process
> in that container.  This write might place restrictions on mount
> namespaces required to define a container, or at least careful checking
> of namespaces in the kernel to verify permissions of the orchestrator so
> it can't change its own container ID.  A bind mount of nsfs may be
> necessary in the container orchestrator's mount namespace.  This write
> can only happen once per process.
>
> Note: The justification for using a u64 is that it minimizes the
> information printed in every audit record, reducing bandwidth and limits
> comparisons to a single u64 which will be faster and less error-prone.

I know Steve generally worries about audit record size, which is a
perfectly valid concern in this case, I also worry about the
additional overhead when we start routing audit records to multiple
audit daemons (see my other emails in this thread).

> ...
> When a container ceases to exist because the last process in that
> container has exited log the fact to balance the registration action.
> (This is likely needed for certification accountability.)

On the "container ceases to exist" point, I expect this "container
dead" message to come from the orchestrator and not the kernel itself
(I don't want the kernel to have to handle that level of bookkeeping).
I imagine this should be similar to what is done for VM auditing with
libvirt.

-- 
paul moore
www.paul-moore.com
