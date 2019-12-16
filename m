From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH] openat2: switch to __attribute__((packed)) for open_how
Date: Mon, 16 Dec 2019 16:55:44 +0000
Message-ID: <b26ef210ec5b42009cf09b1015065768@AcuMS.aculab.com>
References: <20191213222351.14071-1-cyphar@cyphar.com>
 <a328b91d-fd8f-4f27-b3c2-91a9c45f18c0@rasmusvillemoes.dk>
 <20191215123443.jmfnrtgbscdwfohc@yavin.dot.cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191215123443.jmfnrtgbscdwfohc@yavin.dot.cyphar.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: 'Aleksa Sarai' <cyphar@cyphar.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Shuah Khan <shuah@kernel.org>, "dev@opencontainers.org" <dev@opencontainers.org>, "containers@lists.linux-foundation.org" <containers@lists.linux-foundation.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

From:  Aleksa Sarai
> Sent: 15 December 2019 12:35
> On 2019-12-14, Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:
> > On 13/12/2019 23.23, Aleksa Sarai wrote:
> > > The design of the original open_how struct layout was such that it
> > > ensured that there would be no un-labelled (and thus potentially
> > > non-zero) padding to avoid issues with struct expansion, as well as
> > > providing a uniform representation on all architectures (to avoid
> > > complications with OPEN_HOW_SIZE versioning).
> > >
> > > However, there were a few other desirable features which were not
> > > fulfilled by the previous struct layout:
> > >
> > >  * Adding new features (other than new flags) should always result in
> > >    the struct getting larger. However, by including a padding field, it
> > >    was possible for new fields to be added without expanding the
> > >    structure. This would somewhat complicate version-number based
> > >    checking of feature support.
> > >
> > >  * A non-zero bit in __padding yielded -EINVAL when it should arguably
> > >    have been -E2BIG (because the padding bits are effectively
> > >    yet-to-be-used fields). However, the semantics are not entirely clear
> > >    because userspace may expect -E2BIG to only signify that the
> > >    structure is too big. It's much simpler to just provide the guarantee
> > >    that new fields will always result in a struct size increase, and
> > >    -E2BIG indicates you're using a field that's too recent for an older
> > >    kernel.
> >
> > And when the first extension adds another u64 field, that padding has to
> > be added back in and checked for being 0, at which point the padding is
> > again yet-to-be-used fields.
> 
> Maybe I'm missing something, but what is the issue with
> 
>   struct open_how {
>     u64 flags;
>     u64 resolve;
>     u16 mode;
> 	u64 next_extension;
>   } __attribute__((packed));

Compile anything that accesses it for (say) sparc and look at the object code.
You really, really, REALLY, don't want to EVER use 'packed'.

Just use u64 for all the fields.
Use 'flags' bits to indicate whether the additional fields should be looked at.
Error if a 'flags' bit requires a value that isn't passed in the structure.

Then you can add an extra field and old source code recompiled with the
new headers will still work - because the 'junk' value isn't looked at.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
