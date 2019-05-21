From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v3] net: Add UNIX_DIAG_UID to Netlink UNIX socket
 diagnostics.
Date: Mon, 20 May 2019 20:12:02 -0400 (EDT)
Message-ID: <20190520.201202.368431080157706787.davem@davemloft.net>
References: <20190519013839.20355-1-felipe@felipegasper.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190519013839.20355-1-felipe@felipegasper.com>
Sender: linux-kernel-owner@vger.kernel.org
To: felipe@felipegasper.com
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Felipe Gasper <felipe@felipegasper.com>
Date: Sat, 18 May 2019 20:38:39 -0500

> Author: Felipe Gasper <felipe@felipegasper.com>
> Date:   Sat May 18 20:04:40 2019 -0500
> 
>    net: Add UNIX_DIAG_UID to Netlink UNIX socket diagnostics.

Please format your patch submission properly.

This Author: and Date: should not be here in the commit message.

The "net: Add UNIX_DIAG_UID to Netlink UNIX socket diagnostics." should
be exclusively in your Subject line.

And:

>    This adds the ability for Netlink to report a socket's UID along with the
>    other UNIX diagnostic information that is already available. This will
>    allow diagnostic tools greater insight into which users control which
>    socket.
> 
>    To test this, do the following as a non-root user:
> 
>         unshare -U -r bash
>         nc -l -U user.socket.$$ &
> 
>    .. and verify from within that same session that Netlink UNIX socket
>    diagnostics report the socket's UID as 0. Also verify that Netlink UNIX
>    socket diagnostics report the socket's UID as the user's UID from an
>    unprivileged process in a different session. Verify the same from
>    a root process.
> 
>    Signed-off-by: Felipe Gasper <felipe@felipegasper.com>

This is all unnecessarily indented.

I know what you did, you took something like "git show" output and
just posted it to the list here.

But that's not what you're supposed to do.

Thanks.
