From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH -v5] random: introduce getrandom(2) system call
Date: Thu, 24 Jul 2014 16:27:54 -0700
Message-ID: <53D1967A.3060609@zytor.com>
References: <1406212287-9855-1-git-send-email-tytso@mit.edu> <20140724151814.GE32421@khazad-dum.debian.net> <CALCETrXAA=UzS-pRCo5tKSjSCOP9xfu66BG9QbRefVrovkavhQ@mail.gmail.com> <20140724190206.GL6673@thunk.org> <20140724203019.GA20737@khazad-dum.debian.net> <CALCETrXtNUSCQEZ+SKJ5Br41rnF35kGqStkFuX6dN-3z5hVdmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrXtNUSCQEZ+SKJ5Br41rnF35kGqStkFuX6dN-3z5hVdmQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>, Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Theodore Ts'o <tytso@mit.edu>, Linux Kernel Developers List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-crypto@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 07/24/2014 01:54 PM, Andy Lutomirski wrote:
> 
> Or that someone writes userspace code that gets -EPERM/-EACCESS on
> getrandom with GRND_RANDOM and falls back to something worse than
> getrandom w/o GRND_RANDOM.
> 

-ENXIO?

	-hpa
