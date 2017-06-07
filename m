From: Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH v2] firmware: fix sending -ERESTARTSYS due to signal on
 fallback
Date: Wed, 07 Jun 2017 13:25:51 +0100
Message-ID: <1496838351.5682.58.camel@linux.intel.com>
References: <20170526194640.GS8951@wotan.suse.de>
         <CAKdAkRTrcTVOAP5GK-R=Au_tL5WqSn5UkQEzNe5NcCWXS8mbtA@mail.gmail.com>
         <CAB=NE6Wh9inuA-R9-zegnvJV=s_6o_doMNDOhBVhYn4ZQ_Ku5Q@mail.gmail.com>
         <20170526215518.GB40877@dtor-ws> <20170605202410.GQ8951@wotan.suse.de>
         <1496760796.5682.48.camel@linux.intel.com>
         <20170606164734.GB27288@wotan.suse.de>
         <20170606221151.ygoxqkwhhjsqw632@thunk.org>
         <20170607002237.GJ27288@wotan.suse.de>
         <CALCETrVi2_9-+SnyF6TzUDJfrJs6E_3uAncjKP=44zzY1xGwZg@mail.gmail.com>
         <20170607062515.GA23434@dtor-ws>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170607062515.GA23434@dtor-ws>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Andy Lutomirski <luto@kernel.org>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Stephen Boyd <stephen.boyd@linaro.org>, "Li, Yi" <yi1.li@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Jonathan Corbet <corbet@lwn.net>, "Eric W. Biederman" <ebiederm@xmission.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Greg KH <gregkh@linuxfoundation.org>, "Fuzzey, Martin" <mfuzzey@parkeon.com>, Linux API <linux-api@vger.kernel.org>, Daniel Wagner <wagi@monom.org>, David Woodhouse <dwmw2@infradead.org>, jewalt@lgsinnovations.com, rafal@milecki.pl, Arend Van Spriel <arend.vanspriel@broadcom.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, atull@opensource.altera.com, Moritz Fischer <moritz.fischer@>
List-Id: linux-api@vger.kernel.org

> What's wrong with saying that the only way to interrupt firmware
> loading is to kill the process? So ctrl-c will no longer interrupt
> it, but I do not think that ease of aborting firmware update is
> primary goal here. I consider simple is good here.

Agreed 100%. The user process did not ask for firmware load, it asked
for an I/O operation. Semantically it should appear as if someone else
did the firmware load and it just had to wait for it to happen.

Alan
