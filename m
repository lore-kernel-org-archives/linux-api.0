From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v4 21/79] ebtables.h: use __u64 from linux/types.h
Date: Mon, 23 Nov 2015 17:55:00 +0100
Message-ID: <20151123165500.GA5046@salvia>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
 <1444888618-4506-22-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1444888618-4506-22-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>, Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>, Geert Uytterhoeven <geert+renesas@glider.be>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Oct 15, 2015 at 07:55:59AM +0200, Mikko Rapeli wrote:
> Fixes userspace compilation error:
>=20
> linux/netfilter_bridge/ebtables.h:38:2: error: unknown type name =E2=80=
=98uint64_t=E2=80=99

Applied, thanks.
