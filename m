From: David Vrabel <david.vrabel@citrix.com>
Subject: Re: [Xen-devel] [PATCH v4 29/79] gntalloc.h: use __u16, __u32 and
 __u64 from linux/types.h
Date: Thu, 15 Oct 2015 11:55:59 +0100
Message-ID: <561F863F.3050402@citrix.com>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
 <1444888618-4506-30-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444888618-4506-30-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikko Rapeli <mikko.rapeli@iki.fi>, linux-kernel@vger.kernel.org
Cc: David Vrabel <david.vrabel@citrix.com>, linux-api@vger.kernel.org, xen-devel@lists.xenproject.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>
List-Id: linux-api@vger.kernel.org

On 15/10/15 06:56, Mikko Rapeli wrote:
> Fixes userspace compilation errors like:
>=20
> xen/gntalloc.h:22:2: error: unknown type name =E2=80=98uint16_t=E2=80=
=99

Applied to for-linus-4.4, thanks.

David
