From: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
Subject: Does anyone know when FUTEX_WAIT can fail with EAGAIN?
Date: Tue, 29 Jul 2014 21:55:56 +0000 (GMT)
Message-ID: <fb82d1d46d8f.53d8186c@langara.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-disposition: inline
Content-language: en
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, mtk@man7.org
List-Id: linux-api@vger.kernel.org

Hello,

I'm trying to debug a hangup where my program loops with FUTEX_WAIT (actually
FUTEX_WAIT_PRIVATE but same thing)  endlessly erring out with EAGAIN. I would
like to know if anyone on the mailing list knows when FUTEX_WAIT can fail with
EAGAIN.

Some info for people who are interested in what I'm working on.

I'm working on sand boxing my program at gitorious.org/linted with namespaces
and chroot.

The error only appeared after changing unshare then fork code into a direct
clone call.

> | uname -a
> Linux alonzo 3.13.0-24-generic #1trisquel1 SMP Tue May 13 15:17:50 UTC 2014
x86_64 x86_64 x86_64 GNU/Linux

Thank you,
Steven Stewart-Gallus
