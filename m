From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 15/45] dm-log-userspace.h: include stdint.h in userspace
Date: Mon, 16 Feb 2015 18:32:54 -0500
Message-ID: <20150216233254.GA23033@redhat.com>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
 <1424127948-22484-16-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1424127948-22484-16-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Feb 16 2015 at  6:05pm -0500,
Mikko Rapeli <mikko.rapeli@iki.fi> wrote:

> Fixes compilation error:
>=20
> linux/dm-log-userspace.h:416:2: error: unknown type name =E2=80=98uin=
t64_t=E2=80=99

What userspace code are you compiling?  Do you have a feel for when thi=
s
stopped working?
