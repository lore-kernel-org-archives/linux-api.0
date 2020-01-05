From: Sargun Dhillon <sargun@sargun.me>
Subject: Re: [PATCH v8 3/3] test: Add test for pidfd getfd
Date: Sun, 5 Jan 2020 19:08:13 +0000
Message-ID: <20200105190812.GC8522@ircssh-2.c.rugged-nimbus-611.internal>
References: <20200103162928.5271-1-sargun@sargun.me>
 <20200103162928.5271-4-sargun@sargun.me>
 <20200105142019.umls5ff4b5433u6k@wittgenstein>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200105142019.umls5ff4b5433u6k@wittgenstein>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Sargun Dhillon <sargun@sargun.me>, tycho@tycho.ws, jannh@google.com, cyphar@cyphar.com, christian.brauner@ubuntu.com, oleg@redhat.com, luto@amacapital.net, viro@zeniv.linux.org.uk, gpascutto@mozilla.com, ealvarez@mozilla.com, fweimer@redhat.com, jld@mozilla.com, arnd@arndb.de
List-Id: linux-api@vger.kernel.org

On Sun, Jan 05, 2020 at 03:20:23PM +0100, Christian Brauner wrote:
> On Fri, Jan 03, 2020 at 08:29:28AM -0800, Sargun Dhillon wrote:
> > +static int sys_pidfd_getfd(int pidfd, int fd, int flags)
> > +{
> > +	return syscall(__NR_pidfd_getfd, pidfd, fd, flags);
> > +}
> 
> I think you can move this to the pidfd.h header as:
> 
> static inline int sys_pidfd_getfd(int pidfd, int fd, int flags)
> {
> 	return syscall(__NR_pidfd_getfd, pidfd, fd, flags);
> }
> 
> Note, this also needs an
> 
> #ifndef __NR_pidfd_getfd
> __NR_pidfd_getfd -1
> #endif
> so that compilation doesn't fail.
> 
I'll go ahead and move this into pidfd.h, and follow the pattern there. I
don't think it's worth checking if each time the return code is ENOSYS.

Does it make sense to add something like:
#ifdef __NR_pidfd_getfd
TEST_HARNESS_MAIN
#else
int main(void)
{
	fprintf(stderr, "pidfd_getfd syscall not supported\n");
	return KSFT_SKIP;
}
#endif

to short-circuit the entire test suite?


> > +
> > +static int sys_memfd_create(const char *name, unsigned int flags)
> > +{
> > +	return syscall(__NR_memfd_create, name, flags);
> > +}
> > +
> > +static int __child(int sk, int memfd)
> > +{
> > +	int ret;
> > +	char buf;
> > +
> > +	/*
> > +	 * Ensure we don't leave around a bunch of orphaned children if our
> > +	 * tests fail.
> > +	 */
> > +	ret = prctl(PR_SET_PDEATHSIG, SIGKILL);
> > +	if (ret) {
> > +		fprintf(stderr, "%s: Child could not set DEATHSIG\n",
> > +			strerror(errno));
> > +		return EXIT_FAILURE;
> 
> return -1
> 
> > +	}
> > +
> > +	ret = send(sk, &memfd, sizeof(memfd), 0);
> > +	if (ret != sizeof(memfd)) {
> > +		fprintf(stderr, "%s: Child failed to send fd number\n",
> > +			strerror(errno));
> > +		return EXIT_FAILURE;
> 
> return -1
> 
> > +	}
> > +
> > +	while ((ret = recv(sk, &buf, sizeof(buf), 0)) > 0) {
> > +		if (buf == 'P') {
> > +			ret = prctl(PR_SET_DUMPABLE, 0);
> > +			if (ret < 0) {
> > +				fprintf(stderr,
> > +					"%s: Child failed to disable ptrace\n",
> > +					strerror(errno));
> > +				return EXIT_FAILURE;
> 
> return -1
> 
> > +			}
> > +		} else {
> > +			fprintf(stderr, "Child received unknown command %c\n",
> > +				buf);
> > +			return EXIT_FAILURE;
> 
> return -1
> 
> > +		}
> > +		ret = send(sk, &buf, sizeof(buf), 0);
> > +		if (ret != 1) {
> > +			fprintf(stderr, "%s: Child failed to ack\n",
> > +				strerror(errno));
> > +			return EXIT_FAILURE;
> 
> return -1
> 
> > +		}
> > +	}
> > +
> > +	if (ret < 0) {
> > +		fprintf(stderr, "%s: Child failed to read from socket\n",
> > +			strerror(errno));
> 
> Is this intentional that this is no failure?
> 
My thought here, is the only case where this should happen is if the "ptrace 
command" was not properly "transmitted", and the ptrace test itself would fail.

I can add an explicit exit failure here.

> > +	}
> > +
> > +	return EXIT_SUCCESS;
> 
> return 0
> 
> > +}
> > +
> > +static int child(int sk)
> > +{
> > +	int memfd, ret;
> > +
> > +	memfd = sys_memfd_create("test", 0);
> > +	if (memfd < 0) {
> > +		fprintf(stderr, "%s: Child could not create memfd\n",
> > +			strerror(errno));
> > +		ret = EXIT_FAILURE;
> 
> ret = -1;
> 
> > +	} else {
> > +		ret = __child(sk, memfd);
> > +		close(memfd);
> > +	}
> > +
> > +	close(sk);
> > +	return ret;
> > +}
> > +
> > +FIXTURE(child)
> > +{
> > +	pid_t pid;
> > +	int pidfd, sk, remote_fd;
> > +};
> > +
> > +FIXTURE_SETUP(child)
> > +{
> > +	int ret, sk_pair[2];
> > +
> > +	ASSERT_EQ(0, socketpair(PF_LOCAL, SOCK_SEQPACKET, 0, sk_pair))
> > +	{
> > +		TH_LOG("%s: failed to create socketpair", strerror(errno));
> > +	}
> > +	self->sk = sk_pair[0];
> > +
> > +	self->pid = fork();
> > +	ASSERT_GE(self->pid, 0);
> > +
> > +	if (self->pid == 0) {
> > +		close(sk_pair[0]);
> > +		exit(child(sk_pair[1]));
> 
> if (child(sk_pair[1]))
> 	_exit(EXIT_FAILURE);
> _exit(EXIT_SUCCESS);
> 
> I would like to only use exit macros where one actually calls
> {_}exit()s. It makes the logic easier to follow and ensures that one
> doesn't accidently do an exit(-21345) or something (e.g. when adding new
> code).
> 
> > +	}
> > +
> > +	close(sk_pair[1]);
> > +
> > +	self->pidfd = sys_pidfd_open(self->pid, 0);
> > +	ASSERT_GE(self->pidfd, 0);
> > +
> > +	/*
> > +	 * Wait for the child to complete setup. It'll send the remote memfd's
> > +	 * number when ready.
> > +	 */
> > +	ret = recv(sk_pair[0], &self->remote_fd, sizeof(self->remote_fd), 0);
> > +	ASSERT_EQ(sizeof(self->remote_fd), ret);
> > +}
> > +
> > +FIXTURE_TEARDOWN(child)
> > +{
> > +	int status;
> > +
> > +	EXPECT_EQ(0, close(self->pidfd));
> > +	EXPECT_EQ(0, close(self->sk));
> > +
> > +	EXPECT_EQ(waitpid(self->pid, &status, 0), self->pid);
> > +	EXPECT_EQ(true, WIFEXITED(status));
> > +	EXPECT_EQ(0, WEXITSTATUS(status));
> > +}
> > +
> > +TEST_F(child, disable_ptrace)
> > +{
> > +	int uid, fd;
> > +	char c;
> > +
> > +	/*
> > +	 * Turn into nobody if we're root, to avoid CAP_SYS_PTRACE
> > +	 *
> > +	 * The tests should run in their own process, so even this test fails,
> > +	 * it shouldn't result in subsequent tests failing.
> > +	 */
> > +	uid = getuid();
> > +	if (uid == 0)
> > +		ASSERT_EQ(0, seteuid(USHRT_MAX));
> 
> Hm, isn't it safer to do 65535 explicitly? Since USHRT_MAX can
> technically be greater than 65535.
> 
I borrowed this from the BPF tests. I can hardcode something like:
#define NOBODY_UID 65535
and setuid to that, if you think it's safer?

> > +
> > +	ASSERT_EQ(1, send(self->sk, "P", 1, 0));
> > +	ASSERT_EQ(1, recv(self->sk, &c, 1, 0));
> > +
> > +	fd = sys_pidfd_getfd(self->pidfd, self->remote_fd, 0);
> > +	EXPECT_EQ(-1, fd);
> > +	EXPECT_EQ(EPERM, errno);
> > +
> > +	if (uid == 0)
> > +		ASSERT_EQ(0, seteuid(0));
> > +}
> > +
> > +TEST_F(child, fetch_fd)
> > +{
> > +	int fd, ret;
> > +
> > +	fd = sys_pidfd_getfd(self->pidfd, self->remote_fd, 0);
> > +	ASSERT_GE(fd, 0);
> > +
> > +	EXPECT_EQ(0, sys_kcmp(getpid(), self->pid, KCMP_FILE, fd, self->remote_fd));
> 
> So most of these tests seem to take place when the child has already
> called exit() - or at least it's very likely that the child has already
> called exit() - and remains a zombie. That's not ideal because
> that's not the common scenario/use-case. Usually the task of which we
> want to get an fd will be alive. Also, if the child has already called
> exit(), by the time it returns to userspace it should have already
> called exit_files() and so I wonder whether this test would fail if it's
> run after the child has exited. Maybe I'm missing something here... Is
> there some ordering enforced by TEST_F()?
Yeah, I think perhaps I was being too clever.
The timeline roughly goes something like this:

# Fixture bringup
[parent] creates socket_pair
[parent] forks, and passes pair down to child
[parent] waits to read sizeof(int) from the sk_pair
[child] creates memfd 
[__child] sends local memfd number to parent via sk_pair
[__child] waits to read from sk_pair
[parent] reads remote memfd number from socket
# Test
[parent] performs tests
# Fixture teardown
[parent] closes sk_pair
[__child] reads 0 from recv on sk_pair, implies the other end is closed
[__child] Returns / exits 0
[parent] Reaps child / reads exit code

---
The one case where this is not true, is if the parent sends 'P' to the sk pair,
it triggers setting PR_SET_DUMPABLE to 0, and then resumes waiting for the fd to 
close.

Maybe I'm being too clever? Instead, the alternative was to send explicit stop / 
start messages across the sk_pair, but that got kind of ugly. Do you have a 
better suggestion?

> 
> Also, what does self->pid point to? The fd of the already exited child?
It's just the pid of the child. pidfd is the fd of the (unexited) child.
