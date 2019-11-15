From: David Howells <dhowells@redhat.com>
Subject: Re: [pipe] d60337eff1: BUG:kernel_NULL_pointer_dereference,address
Date: Fri, 15 Nov 2019 16:22:26 +0000
Message-ID: <6853.1573834946@warthog.procyon.org.uk>
References: <9279.1573824532@warthog.procyon.org.uk> <20191110031348.GE29418@shao2-debian>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9279.1573824532@warthog.procyon.org.uk>
Content-ID: <6852.1573834946.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: kernel test robot <lkp@intel.com>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, lkp@lists.01.org
List-Id: linux-api@vger.kernel.org

Actually, no, this is the fix:

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 7006b5b2106d..be2fc5793ddd 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -537,7 +537,7 @@ static size_t push_pipe(struct iov_iter *i, size_t size=
,
 =09=09buf->ops =3D &default_pipe_buf_ops;
 =09=09buf->page =3D page;
 =09=09buf->offset =3D 0;
-=09=09buf->len =3D max_t(ssize_t, left, PAGE_SIZE);
+=09=09buf->len =3D min_t(ssize_t, left, PAGE_SIZE);
 =09=09left -=3D buf->len;
 =09=09iter_head++;
 =09=09pipe->head =3D iter_head;

David
