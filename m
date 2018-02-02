From: Paul Moore <paul@paul-moore.com>
Subject: Re: RFC(V3): Audit Kernel Container IDs
Date: Fri, 2 Feb 2018 16:24:26 -0500
Message-ID: <CAHC9VhQ=hX55e7ftkVQCogTZTcdSm3rm-+YNOgWomabbXV_sKg@mail.gmail.com>
References: <20180109121620.wi7dq2423ugsraqv@madcap2.tricolour.ca>
 <1515514736.3239.10.camel@redhat.com> <20180110070011.l4rcdcwb27witfem@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180110070011.l4rcdcwb27witfem@madcap2.tricolour.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Guy Briggs <rgb@redhat.com>
Cc: Simo Sorce <simo@redhat.com>, David Howells <dhowells@redhat.com>, cgroups@vger.kernel.org, jlayton@redhat.com, trondmy@primarydata.com, "Serge E. Hallyn" <serge@hallyn.com>, mszeredi@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Eric Paris <eparis@parisplace.org>, Carlos O'Donell <carlos@redhat.com>, Linux API <linux-api@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Linux Audit <linux-audit@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux Network Development <netdev@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 10, 2018 at 2:00 AM, Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2018-01-09 11:18, Simo Sorce wrote:
>> On Tue, 2018-01-09 at 07:16 -0500, Richard Guy Briggs wrote:
>> > Containers are a userspace concept.  The kernel knows nothing of them.
>> >
>> > The Linux audit system needs a way to be able to track the container
>> > provenance of events and actions.  Audit needs the kernel's help to do
>> > this.
>> >
>> > Since the concept of a container is entirely a userspace concept, a
>> > registration from the userspace container orchestration system initiates
>> > this.  This will define a point in time and a set of resources
>> > associated with a particular container with an audit container
>> > identifier.
>> >
>> > The registration is a u64 representing the audit container identifier
>> > written to a special file in a pseudo filesystem (proc, since PID tree
>> > already exists) representing a process that will become a parent process
>> > in that container.  This write might place restrictions on mount
>> > namespaces required to define a container, or at least careful checking
>> > of namespaces in the kernel to verify permissions of the orchestrator so
>> > it can't change its own container ID.  A bind mount of nsfs may be
>> > necessary in the container orchestrator's mount namespace.  This write
>> > can only happen once per process.
>> >
>> > Note: The justification for using a u64 is that it minimizes the
>> > information printed in every audit record, reducing bandwidth and limits
>> > comparisons to a single u64 which will be faster and less error-prone.
>> >
>> > Require CAP_AUDIT_CONTROL to be able to carry out the registration.  At
>> > that time, record the target container's user-supplied audit container
>> > identifier along with a target container's parent process (which may
>> > become the target container's "init" process) process ID (referenced
>> > from the initial PID namespace) in a new record AUDIT_CONTAINER with a
>> > qualifying op=$action field.
>> >
>> > Issue a new auxilliary record AUDIT_CONTAINER_INFO for each valid
>> > container ID present on an auditable action or event.
>> >
>> > Forked and cloned processes inherit their parent's audit container
>> > identifier, referenced in the process' task_struct.  Since the audit
>> > container identifier is inherited rather than written, it can still be
>> > written once.  This will prevent tampering while allowing nesting.
>> > (This can be implemented with an internal settable flag upon
>> > registration that does not get copied across a fork/clone.)
>> >
>> > Mimic setns(2) and return an error if the process has already initiated
>> > threading or forked since this registration should happen before the
>> > process execution is started by the orchestrator and hence should not
>> > yet have any threads or children.  If this is deemed overly restrictive,
>> > switch all of the target's threads and children to the new containerID.
>> >
>> > Trust the orchestrator to judiciously use and restrict CAP_AUDIT_CONTROL.
>> >
>> > When a container ceases to exist because the last process in that
>> > container has exited log the fact to balance the registration action.
>> > (This is likely needed for certification accountability.)
>> >
>> > At this point it appears unnecessary to add a container session
>> > identifier since this is all tracked from loginuid and sessionid to
>> > communicate with the container orchestrator to spawn an additional
>> > session into an existing container which would be logged.  It can be
>> > added at a later date without breaking API should it be deemed
>> > necessary.
>> >
>> > The following namespace logging actions are not needed for certification
>> > purposes at this point, but are helpful for tracking namespace activity.
>> > These are auxilliary records that are associated with namespace
>> > manipulation syscalls unshare(2), clone(2) and setns(2), so the records
>> > will only show up if explicit syscall rules have been added to document
>> > this activity.
>> >
>> > Log the creation of every namespace, inheriting/adding its spawning
>> > process' audit container identifier(s), if applicable.  Include the
>> > spawning and spawned namespace IDs (device and inode number tuples).
>> > [AUDIT_NS_CREATE, AUDIT_NS_DESTROY] [clone(2), unshare(2), setns(2)]
>> > Note: At this point it appears only network namespaces may need to track
>> > container IDs apart from processes since incoming packets may cause an
>> > auditable event before being associated with a process.  Since a
>> > namespace can be shared by processes in different containers, the
>> > namespace will need to track all containers to which it has been
>> > assigned.
>> >
>> > Upon registration, the target process' namespace IDs (in the form of a
>> > nsfs device number and inode number tuple) will be recorded in an
>> > AUDIT_NS_INFO auxilliary record.
>> >
>> > Log the destruction of every namespace that is no longer used by any
>> > process, including the namespace IDs (device and inode number tuples).
>> > [AUDIT_NS_DESTROY] [process exit, unshare(2), setns(2)]
>> >
>> > Issue a new auxilliary record AUDIT_NS_CHANGE listing (opt: op=$action)
>> > the parent and child namespace IDs for any changes to a process'
>> > namespaces. [setns(2)]
>> > Note: It may be possible to combine AUDIT_NS_* record formats and
>> > distinguish them with an op=$action field depending on the fields
>> > required for each message type.
>> >
>> > The audit container identifier will need to be reaped from all
>> > implicated namespaces upon the destruction of a container.
>> >
>> > This namespace information adds supporting information for tracking
>> > events not attributable to specific processes.
>> >
>> > Changelog:
>> >
>> > (Upstream V3)
>> > - switch back to u64 (from pmoore, can be expanded to u128 in future if
>> >   need arises without breaking API.  u32 was originally proposed, up to
>> >   c36 discussed)
>> > - write-once, but children inherit audit container identifier and can
>> >   then still be written once
>> > - switch to CAP_AUDIT_CONTROL
>> > - group namespace actions together, auxilliary records to namespace
>> >   operations.
>> >
>> > (Upstream V2)
>> > - switch from u64 to u128 UUID
>> > - switch from "signal" and "trigger" to "register"
>> > - restrict registration to single process or force all threads and
>> >   children into same container
>>
>> I am trying to understand the back and forth on the ID size.
>>
>> From an orchestrator POV anything that requires tracking a node
>> specific ID is not ideal.
>>
>> Orchestrators tend to span many nodes, and containers tend to have IDs
>> that are either UUID or have a Hash (like SHA256) as identifier.
>>
>> The problem here is two-fold:
>>
>> a) Your auditing requires some mapping to be useful outside of the
>> system.
>> If you aggreggate audit logs outside of the system or you want to
>> correlate the system audit logs with other components dealing with
>> containers, now you need a place where you provide a mapping from your
>> audit u64 to the ID a container has in the rest of the system.
>>
>> b) Now you need a mapping of some sort. The simplest way a container
>> orchestrator can go about this is to just use the UUID or Hash
>> representing their view of the container, truncate it to a u64 and use
>> that for Audit. This means there are some chances there will be a
>> collision and a duplicate u64 ID will be used by the orchestrator as
>> the container ID. What happen in that case ?
>
> Paul, can you justify this somewhat larger inconvenience for some
> relatively minor convenience on our part?

Done in direct response to Simo.

But to be clear Richard, we've talked about this a few times, it's not
a "minor convenience" on our part, it's a pretty big convenience once
we starting having to route audit events and make decisions based on
the audit container ID information.  Audit performance is less than
awesome now, I'm working hard to not make it worse.

> u64 vs u128 is easy for us to
> accomodate in terms of scalar comparisons.  It doubles the information
> in every container id field we print in audit records.

... and slows down audit container ID checks.

> A c36 is a bigger step.

Yeah, we're not doing that, no way.

-- 
paul moore
www.paul-moore.com
