From: Eric Wong <normalperson@yhbt.net>
Subject: Re: Does anyone know when FUTEX_WAIT can fail with EAGAIN?
Date: Sat, 16 Aug 2014 21:51:04 +0000
Message-ID: <20140816215104.GA19006@dcvr.yhbt.net>
References: <fb82d1d46d8f.53d8186c@langara.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <fb82d1d46d8f.53d8186c@langara.bc.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, mtk@man7.org
List-Id: linux-api@vger.kernel.org

Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca> wrote:
> I'm trying to debug a hangup where my program loops with FUTEX_WAIT (actually
> FUTEX_WAIT_PRIVATE but same thing)  endlessly erring out with EAGAIN. I would
> like to know if anyone on the mailing list knows when FUTEX_WAIT can fail with
> EAGAIN.

FUTEX_WAIT fails with EAGAIN if the value of *uaddr no longer matches
the expected val.
---
#include <linux/futex.h>
#include <sys/syscall.h>
#include <unistd.h>
#include <errno.h>
int main(void) {
	int op = FUTEX_WAIT;
	int exp = 1;
	int *addr = &exp;
	int val = 1; /* XXX change this to anything else to get EAGAIN */
	int rc = syscall(SYS_futex, addr, op, val, 0, 0, 0);

	if (rc < 0 && errno == EAGAIN)
		write(1, "EAGAIN\n", 7);

	return 0;
}
---
I just encountered this myself yesterday while implementing futex-based
locks/condvars for Ruby:
https://bugs.ruby-lang.org/issues/10009#change-48372
