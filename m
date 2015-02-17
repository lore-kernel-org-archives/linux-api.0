From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 43/45] include/uapi/linux/netfilter_bridge.h: include
 if.h
Date: Tue, 17 Feb 2015 01:02:50 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1502170101520.32748@nerf60.vanv.qr>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi> <1424127948-22484-44-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424127948-22484-44-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tuesday 2015-02-17 00:05, Mikko Rapeli wrote:

>Fixes userspace compilation errors like:
>
>error: field =E2=80=98in=E2=80=99 has incomplete type
>struct in_addr in;
>=20
>+#include <linux/if.h>

Patch 36/45 included linux/in.h instead of linux/if.h for addressing "i=
n has incomplete
type". Should this be used here too?
