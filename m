From: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH v27 10/12] LRNG - add SP800-90B compliant health tests
Date: Fri, 10 Jan 2020 09:27:20 +0100
Message-ID: <1988924.7r6H7Qibty@tauon.chronox.de>
References: <6157374.ptSnyUpaCn@positron.chronox.de> <2325404.ZKTBb4nKji@positron.chronox.de> <cd9e893a-ce63-4e9a-fc19-553b1c5f1cff@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cd9e893a-ce63-4e9a-fc19-553b1c5f1cff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "Alexander E. Patrakov" <patrakov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Ahmed S. Darwish" <darwish.07-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Theodore Y. Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Vito Caputo <vcaputo-IiWei5kqaphBDgjK7y7TUQ@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Ray Strode <rstrode-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, William Jon McCann <mccann-4GNroTWusrE@public.gmane.org>, zhangjs <zachary-+jQ8zvd9CV5SzTKKI/wJ2A@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>, Nicolai Stange <nstange@sus>
List-Id: linux-api@vger.kernel.org

Am Freitag, 10. Januar 2020, 01:20:44 CET schrieb Randy Dunlap:

Hi Randy,

I have removed the two stars in front of each comment.

I have also fixed the respective comments in lrng_interfaces.c, 
lrng_archrandom.c, lrng_chacha20.c, lrng_drng.c, lrng_pool.c, lrng_switch.c, 
lrng_sw_noise.c. In all other files there were no changes needed.

Thank you.


Ciao
Stephan
