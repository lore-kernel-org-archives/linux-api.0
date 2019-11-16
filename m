From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH v25 03/12] LRNG - /proc interface
Date: Sat, 16 Nov 2019 17:36:25 -0600
Message-ID: <87k17z4cna.fsf@x220.int.ebiederm.org>
References: <6157374.ptSnyUpaCn@positron.chronox.de>
        <2787174.DQlWHN5GGo@positron.chronox.de>
        <2476454.l8LQlgn7Hv@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2476454.l8LQlgn7Hv@positron.chronox.de> ("Stephan
 \=\?utf-8\?Q\?M\=C3\=BCller\=22's\?\=
        message of "Sat, 16 Nov 2019 10:34:12 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Stephan =?utf-8?Q?M=C3=BCller?= <smueller@chronox.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Alexander E. Patrakov" <patrakov@gmail.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Vito Caputo <vcaputo@pengaru.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>, William Jon McCann <mccann@jhu.edu>, zhangjs <zachary@baishancloud.com>, Andy Lutomirski <luto@kernel.org>, Florian Weimer <fweimer@redhat.com>, Lennart Poettering <mzxreary@0pointer.de>, Nicolai Stange <nstange@suse.de>, "Peter, Matthias" <matthias.peter@bsi>
List-Id: linux-api@vger.kernel.org

Stephan Müller <smueller@chronox.de> writes:

> The LRNG /proc interface provides the same files as the legacy
> /dev/random. These files behave identically. Yet, all files are
> documented at [1].

For someone who works in this area a lot this description is confusing.

You are talking about sysctls not ordinary proc files.

You don't have a call register_sysctl.  If you want your own
implementation of these sysctls that would seem to be the way to get
them.  Teach each implementation to register their own set of sysctls
if they are enabled.

The entire structure of the code you are adding I have quite confusing,
and a bit messing.

Why add a declaration of random_table in patch 1 and then delete that
declaration in patch 3?  Nothing uses that declaration until this point.

What is the point of adding an extern declaration just before you
declare the table itself?  As I understand the C language that achieves
nothing.  I understand that is what the existing code in
drivers/char/random.c does but that is equally buggy there.

I also don't understand why you don't modify the existing random
generator code into the form you want?  What is the point of a
side-by-side replacement?  Especially since only one of them can
be compiled into the kernel at the same time?

This build a replacement and then switch over seems like a recipe for
loosing the lessons of history because you are not making incremental
changes that can be clearly understood, reviewed and bisected.

As I read your patchset until this change your code will fail to compile
in an ordinary configuration with proc enabled.  Have you even tested
compiling your patchset one patch at a time?

For me a great reorganization to impelment a better structure that fails
to have a good structure on the usual merits makes me dubious about the
entire thing.  As it can be a sign the author was pushing so hard to
make things work he stopped looking at problematic details.

Dubious-by: "Eric W. Biederman" <ebiederm@xmission.com>

Eric

> +
> +extern struct ctl_table random_table[];
> +struct ctl_table random_table[] = {
> +	{
