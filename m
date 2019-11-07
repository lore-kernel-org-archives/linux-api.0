From: David Howells <dhowells@redhat.com>
Subject: Re: [pipe] d60337eff1: phoronix-test-suite.noise-level.0.activity_level 144.0% improvement
Date: Thu, 07 Nov 2019 17:42:18 +0000
Message-ID: <25252.1573148538@warthog.procyon.org.uk>
References: <CAHk-=wiJ+jaT5Ev-wCg7iGNNO_JFUyMDcat0KDdA2b_+n_cZCQ@mail.gmail.com> <157262967752.13142.696874122947836210.stgit@warthog.procyon.org.uk> <20191107090306.GV29418@shao2-debian>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wiJ+jaT5Ev-wCg7iGNNO_JFUyMDcat0KDdA2b_+n_cZCQ@mail.gmail.com>
Content-ID: <25251.1573148538.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, lkp report check <rong.a.chen@intel.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Nicolas Dichtel <nicolas.dichtel@6wind.com>, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, lkp@lists.01.org
List-Id: linux-api@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > FYI, we noticed a 144.0% improvement of phoronix-test-suite.noise-level=
.0.activity_level due to commit:
> >
> > commit: d60337eff18a3c587832ab8053a567f1da9710d2 ("[RFC PATCH 04/11] pi=
pe: Use head and tail pointers for the ring, not cursor and length [ver #3]=
")
>=20
> That sounds nice, but is odd. That commit really shouldn't change
> anything noticeable. David, any idea?

Yeah, it does sound odd - the only thing that springs particularly to mind =
is
that maybe it's an effect of one of the preceding patches that affects the
waitqueue stuff.

TBH, I'm not sure what the Phoronix test suite is actually testing from the
report.  "noise-level-1.1.0" seems more a reporting script than an actual
test.

David
