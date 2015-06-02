From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: Re: [PATCH 30/98] hdspm.h: use __u8, __u32 and __u64 from
 linux/types.h
Date: Tue, 2 Jun 2015 22:18:56 +0300
Message-ID: <20150602191856.GR12550@lakka.kapsi.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
 <1433000370-19509-31-git-send-email-mikko.rapeli@iki.fi>
 <s5ha8wl8blx.wl-tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <s5ha8wl8blx.wl-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sun, May 31, 2015 at 09:11:54AM +0200, Takashi Iwai wrote:
> At Sat, 30 May 2015 17:38:22 +0200,
> Mikko Rapeli wrote:
> >=20
> > Fixes userspace compilation errors like:
> >=20
> > sound/hdspm.h:43:2: error: unknown type name =E2=80=98uint32_t=E2=80=
=99
>=20
> Hmm, how do you get this error at all?
> The header includes stdint.h for user-space.

Yes, sorry. This patch removes the stdint.h include and uses kernel __u=
32
types instead. Will fix the commit message. Thanks!

-Mikko
