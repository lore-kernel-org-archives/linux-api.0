From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH v1 2/4] pid: add pidctl()
Date: Tue, 26 Mar 2019 14:10:12 -0400
Message-ID: <20190326181012.GA138478@google.com>
References: <20190326155513.26964-1-christian@brauner.io>
 <20190326155513.26964-3-christian@brauner.io>
 <20190326170601.GA101741@google.com>
 <20190326172231.daa5a53lxf6nz6jn@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190326172231.daa5a53lxf6nz6jn@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: jannh@google.com, khlebnikov@yandex-team.ru, luto@kernel.org, dhowells@redhat.com, serge@hallyn.com, ebiederm@xmission.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, keescook@chromium.org, adobriyan@gmail.com, tglx@linutronix.de, mtk.manpages@gmail.com, bl0pbl33p@gmail.com, ldv@altlinux.org, akpm@linux-foundation.org, oleg@redhat.com, nagarathnam.muthusamy@oracle.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, dancol@google.com
List-Id: linux-api@vger.kernel.org

On Tue, Mar 26, 2019 at 06:22:33PM +0100, Christian Brauner wrote:
> On Tue, Mar 26, 2019 at 01:06:01PM -0400, Joel Fernandes wrote:
> > On Tue, Mar 26, 2019 at 04:55:11PM +0100, Christian Brauner wrote:
> > > The pidctl() syscalls builds on, extends, and improves translate_pid() [4].
> > > I quote Konstantins original patchset first that has already been acked and
> > > picked up by Eric before and whose functionality is preserved in this
> > > syscall:
> > > 
> > > "Each process have different pids, one for each pid namespace it belongs.
> > >  When interaction happens within single pid-ns translation isn't required.
> > >  More complicated scenarios needs special handling.
> > > 
> > >  For example:
> > >  - reading pid-files or logs written inside container with pid namespace
> > >  - writing logs with internal pids outside container for pushing them into
> > >  - attaching with ptrace to tasks from different pid namespace
> > > 
> > >  Generally speaking, any cross pid-ns API with pids needs translation.
> > > 
> > >  Currently there are several interfaces that could be used here:
> > > 
> > >  Pid namespaces are identified by device and inode of /proc/[pid]/ns/pid.
> > > 
> > >  Pids for nested pid namespaces are shown in file /proc/[pid]/status.
> > >  In some cases pid translation could be easily done using this information.
> > >  Backward translation requires scanning all tasks and becomes really
> > >  complicated for deeper namespace nesting.
> > > 
> > >  Unix socket automatically translates pid attached to SCM_CREDENTIALS.
> > >  This requires CAP_SYS_ADMIN for sending arbitrary pids and entering
> > >  into pid namespace, this expose process and could be insecure."
> > > 
> > > The original patchset allowed two distinct operations implicitly:
> > > - discovering whether pid namespaces (pidns) have a parent-child
> > >   relationship
> > > - translating a pid from a source pidns into a target pidns
> > > 
> > > Both tasks are accomplished in the original patchset by passing a pid
> > > along. If the pid argument is passed as 1 the relationship between two pid
> > > namespaces can be discovered.
> > > The syscall will gain a lot clearer syntax and will be easier to use for
> > > userspace if the task it is asked to perform is passed through a
> > > command argument. Additionally, it allows us to remove an intrinsic race
> > > caused by using the pid argument as a way to discover the relationship
> > > between pid namespaces.
> > > This patch introduces three commands:
> > > 
> > > /* PIDCMD_QUERY_PID */
> > > PIDCMD_QUERY_PID allows to translate a pid between pid namespaces.
> > > Given a source pid namespace fd return the pid of the process in the target
> > > namespace:
> > 
> > Could we call this PIDCMD_TRANSLATE_PID please? QUERY is confusing/ambigious
> > IMO (see below).
> 
> Yes, doesn't matter to me too much what we call it.

Ok.

> > > 1. pidctl(PIDCMD_QUERY_PID, pid, source_fd, -1, 0)
> > >   - retrieve pidns identified by source_fd
> > >   - retrieve struct pid identifed by pid in pidns identified by source_fd
> > >   - retrieve callers pidns
> > >   - return pid in callers pidns
> > > 
> > > 2. pidctl(PIDCMD_QUERY_PID, pid, -1, target_fd, 0)
> > >   - retrieve callers pidns
> > >   - retrieve struct pid identifed by pid in callers pidns
> > >   - retrieve pidns identified by target_fd
> > >   - return pid in pidns identified by target_fd
> > > 
> > > 3. pidctl(PIDCMD_QUERY_PID, 1, source_fd, -1, 0)
> > >   - retrieve pidns identified by source_fd
> > >   - retrieve struct pid identifed by init task in pidns identified by source_fd
> > >   - retrieve callers pidns
> > >   - return pid of init task of pidns identified by source_fd in callers pidns
> > > 
> > > 4. pidctl(PIDCMD_QUERY_PID, pid, source_fd, target_fd, 0)
> > >   - retrieve pidns identified by source_fd
> > >   - retrieve struct pid identifed by pid in pidns identified by source_fd
> > >   - retrieve pidns identified by target_fd
> > >   - check whether struct pid can be found in pidns identified by target_fd
> > >   - return pid in pidns identified by target_fd
> > > 
> > > /* PIDCMD_QUERY_PIDNS */
> > > PIDCMD_QUERY_PIDNS allows to determine the relationship between pid
> > > namespaces.
> > > In the original version of the pachset passing pid as 1 would allow to
> > > deterimine the relationship between the pid namespaces. This is inherhently
> > > racy. If pid 1 inside a pid namespace has died it would report false
> > > negatives. For example, if pid 1 inside of the target pid namespace already
> > > died, it would report that the target pid namespace cannot be reached from
> > > the source pid namespace because it couldn't find the pid inside of the
> > > target pid namespace and thus falsely report to the user that the two pid
> > > namespaces are not related. This problem is simple to avoid. In the new
> > > version we simply walk the list of ancestors and check whether the
> > > namespace are related to each other. By doing it this way we can reliably
> > > report what the relationship between two pid namespace file descriptors
> > > looks like.
> > > 
> > > 1. pidctl(PIDCMD_QUERY_PIDNS, 0, ns_fd1, ns_fd1, 0) == 0
> > >    - pidns_of(ns_fd1) and pidns_of(ns_fd2) are unrelated to each other
> > > 
> > > 2. pidctl(PIDCMD_QUERY_PIDNS, 0, ns_fd1, ns_fd2, 0) == 1
> > >    - pidns_of(ns_fd1) == pidns_of(ns_fd2)
> > > 
> > > 3. pidctl(PIDCMD_QUERY_PIDNS, 0, ns_fd1, ns_fd2, 0) == 2
> > >    - pidns_of(ns_fd1) is ancestor of pidns_of(ns_fd2)
> > > 
> > > 4. pidctl(PIDCMD_QUERY_PIDNS, 0, ns_fd1, ns_fd2, 0) == 3
> > >    - pidns_of(ns_fd2) is ancestor of pidns_of(ns_fd1)
> > 
> > Why not call this PIDCMD_COMPARE_PIDNS, since a comparison is what you're doing.
> 
> Same.

Ok, glad we agree on it.

> > 
> > Again QUERY is ambigious here. Above you called QUERY to translate something,
> > now you're calling QUERY to mean compare something. I suggest to be explicit
> > about the operation PIDCMD_<OPERATION>_<OPERAND-TYPE>.
> > 
> > Arguably, 2 syscalls for this is cleaner:
> > pid_compare_namespaces(ns_fd1, ns_fd2);
> > pid_translate(pid, ns_fd1, nds_fd2);
> 
> I don't think we want to send out pid_compare_namespaces() as a separate
> syscall. If that's the consensus I'd rather just drop this functionality
> completely.

I mean, if pid-namespace fd comparison functionality is not needed in
userspace, why add it all. I suggest to drop it if not needed and can be
considered for addition later when needed.

Then you're just left with GET_PID and TRANSLATE_PID which we know we do need.

> > > These two commands - PIDCMD_QUERY_PID and PIDCMD_QUERY_PIDNS - cover and
> > > improve the functionality expressed implicitly in translate_pid() before.
> > > 
> > > /* PIDCMD_GET_PIDFD */
> > 
> > And this can be a third syscall:
> > pidfd_translate(pid, ns_fd1, ns_fd2).
> 
> Sigh, yes. But I honestly want other people other than us to come out
> and say "yes, please send a PR to Linus with three separate syscalls for
> very closely related functionality". There's a difference between "this
> is how we would ideally like to do it" and "this is what is common
> practice and will likely get accepted". But I'm really not opposed to it
> per se.

Ok.

> > I am actually supportive of Daniel's view that by combining too many
> > arguments into a single syscall, becomes confusing and sometimes some
> > arguments have to be forced to 0 in the single shoe-horned syscall. Like you
> 
> There's a difference between an ioctl() and say seccomp() which this is
> close to:
> int seccomp(unsigned int operation, unsigned int flags, void *args);
> The point is that the functionality is closely related not just randomly
> unrelated stuff. But as I said I'm more than willing to compromise.

Sounds great, yeah whatever makes sense.

Thanks.
