From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v4] net: Add UNIX_DIAG_UID to Netlink UNIX socket
 diagnostics.
Date: Wed, 22 May 2019 10:36:55 -0700 (PDT)
Message-ID: <20190522.103655.1021678724919980639.davem@davemloft.net>
References: <20190521004351.23706-1-felipe@felipegasper.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190521004351.23706-1-felipe@felipegasper.com>
Sender: linux-kernel-owner@vger.kernel.org
To: felipe@felipegasper.com
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Felipe Gasper <felipe@felipegasper.com>
Date: Mon, 20 May 2019 19:43:51 -0500

> This adds the ability for Netlink to report a socket's UID along with the
> other UNIX diagnostic information that is already available. This will
> allow diagnostic tools greater insight into which users control which
> socket.
> 
> To test this, do the following as a non-root user:
> 
>     unshare -U -r bash
>     nc -l -U user.socket.$$ &
> 
> .. and verify from within that same session that Netlink UNIX socket
> diagnostics report the socket's UID as 0. Also verify that Netlink UNIX
> socket diagnostics report the socket's UID as the user's UID from an
> unprivileged process in a different session. Verify the same from
> a root process.
> 
> Signed-off-by: Felipe Gasper <felipe@felipegasper.com>

Applied to net-next, thanks.
