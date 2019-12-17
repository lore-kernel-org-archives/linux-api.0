From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH] openat2: switch to __attribute__((packed)) for open_how
Date: Tue, 17 Dec 2019 10:14:48 +0000
Message-ID: <6630d0573b5b40da8efc58fc20ac445e@AcuMS.aculab.com>
References: <20191213222351.14071-1-cyphar@cyphar.com>
 <a328b91d-fd8f-4f27-b3c2-91a9c45f18c0@rasmusvillemoes.dk>
 <20191215123443.jmfnrtgbscdwfohc@yavin.dot.cyphar.com>
 <b26ef210ec5b42009cf09b1015065768@AcuMS.aculab.com>
 <20191217064650.cd4bfb5d2koe6j7h@yavin.dot.cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191217064650.cd4bfb5d2koe6j7h@yavin.dot.cyphar.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: 'Aleksa Sarai' <asarai@suse.de>
Cc: 'Aleksa Sarai' <cyphar@cyphar.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Shuah Khan <shuah@kernel.org>, "dev@opencontainers.org" <dev@opencontainers.org>, "containers@lists.linux-foundation.org" <containers@lists.linux-foundation.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

>From Aleksa Sarai
> Sent: 17 December 2019 06:47
...
> > Just use u64 for all the fields.
> 
> That is an option (and is the one that clone3 went with), but it's a bit
> awkward because umode_t is a u16 -- and it would be a waste of 6 bytes
> to store it as a u64. Arguably it could be extended but I personally
> find that to be very unlikely (and lots of other syscalls would need be
> updated).

6 bytes on interface structure will make almost no difference.
There is no reason to save more than 16 bits anywhere else.
You could error values with high bits set.

> I'm just going to move the padding to the end and change the error for
> non-zero padding to -E2BIG.

The padding had to be after the u16 field.

> > Use 'flags' bits to indicate whether the additional fields should be looked at.
> > Error if a 'flags' bit requires a value that isn't passed in the structure.
> >
> > Then you can add an extra field and old source code recompiled with the
> > new headers will still work - because the 'junk' value isn't looked at.
> 
> This problem is already handled entirely by copy_struct_from_user().
> 
> It is true that for some new fields it will be necessary to add a new
> flag (such as passing fds -- where 0 is a valid value) but for most new
> fields (especially pointer or flag fields) it will not be necessary
> because the 0 value is equivalent to the old behaviour. It also allows
> us to entirely avoid accepting junk from userspace.

Only if userspace is guaranteed to memset the entire structure
before making the call - rather than just fill in all the fields it knows about.
If it doesn't use memset() then recompiling old code with new headers
will pass garbage to the kernel.
copy_struct_from_user() cannot solve that problem.
You'll never be able to guarantee that all code actually clears the
entire structure - so at some point extending it will break recompilations
of old code - annoying.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
