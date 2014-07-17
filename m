From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH, RFC -v2] random: introduce getrandom(2) system call
Date: Thu, 17 Jul 2014 19:22:25 -0400
Message-ID: <20140717232225.GB1491@thunk.org>
References: <1405633100-4889-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1405633100-4889-1-git-send-email-tytso-3s7WtUTddSA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Kernel Developers List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, beck-7YlrpqBBQ3VAfugRpC6u6w@public.gmane.org
List-Id: linux-api@vger.kernel.org

This is just an update to the commit description (and so I've only
included it_.  A few more minor typos fixedup, and it includes Zach's
reviewed-by.

						- Ted

random: introduce getrandom(2) system call

The getrandom(2) system call was requested by the LibreSSL Portable
developers.  It is analoguous to the getentropy(2) system call in
OpenBSD.

The rationale of this system call is to provide resiliance against
file descriptor exhaustion attacks, where the attacker consumes all
available file descriptors, forcing the use of the fallback code where
/dev/[u]random is not available.  Since the fallback code is often not
well-tested, it is better to eliminate this potential failure mode
entirely.

The other feature provided by this new system call is the ability to
request randomness from the /dev/urandom entropy pool, but to block
until at least 128 bits of entropy has been accumulated in the
/dev/urandom entropy pool.  Historically, the emphasis in the
/dev/urandom development has been to ensure that urandom pool is
initialized as quickly as possible after system boot, and preferably
before the init scripts start execution.

This is because changing /dev/urandom reads to block represents an
interface change that could potentially break userspace which is not
acceptable.  In practice, on most x86 desktop and server systems, in
general the entropy pool can be initialized before it is needed (and
in modern kernels, we will printk a warning message if not).  However,
on an embedded system, this may not be the case.  And so with this new
interface, we can provide the functionality of blocking until the
urandom pool has been initialized.  Any userspace program which uses
this new functionality must take care to assure that if it is used
during the boot process, that it will not cause the init scripts or
other portions of the system startup to hang indefinitely.

SYNOPSIS
	#include <linux/random.h>

	int getrandom(void *buf, size_t buflen, unsigned int flags);

DESCRIPTION
	The system call getrandom() fills the buffer pointed to by buf
	with up to buflen random bytes which can be used to seed user
	space random number generators (i.e., DRBG's) or for other
	cryptographic processes.  It should not be used Monte Carlo
	simulations or for other probabilistic sampling applications.

	If the GRND_RANDOM flags bit is set, then draw from the
	/dev/random pool instead of the /dev/urandom pool.  The
	/dev/random pool is limited based on the entropy that can be
	obtained from environmental noise, so if there is insufficient
	entropy, the requested number of bytes may not be returned.
	If there is no entropy available at all, getrandom(2) will
	either block, or return an error with errno set to EAGAIN if
	the GRND_NONBLOCK bit is set in flags.

	If the GRND_RANDOM bit is not set, then the /dev/urandom pool
	will be used.  Unlike using read(2) to fetch data from
	/dev/urandom, if the urandom pool has not been sufficiently
	initialized, getrandom(2) will block or return -1 with the
	errno set to EGAIN if the GRND_NONBLOCK bit is set in flags.

	The getentropy(2) system call in OpenBSD can be emulated using
	the following function:

	    int getentropy(void *buf, size_t buflen)
	    {
	            int     ret;

		    ret = getentropy(buf, buflen, 0);
		    return (ret > 0) ? 0 : ret;
	    }

RETURN VALUE
       On success, the number of bytes that was filled in the buf is
       returned.  This may not be all the bytes requested by the
       caller via buflen if insufficient entropy was present in the
       /dev/random pool, or if the system call was interrupted by a
       signal.

       On error, -1 is returned, and errno is set appropriately.

ERRORS
	EINVAL		An invalid flag was passed to getrandom(2)

	EFAULT		buf is outside the accessible address space.

	EAGAIN		The requested entropy was not available, and the
			getentropy(2) would have blocked if GRND_BLOCK flag
			was set.

	EINTR		While blocked waiting for entropy, the call was
			interrupted by a signal handler; see the description
			of how interrupted read(2) calls on "slow" devices
			are handled with and without the SA_RESTART flag
			in the signal(7) man page.

Signed-off-by: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Reviewed-by: Zach Brown <zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org>
