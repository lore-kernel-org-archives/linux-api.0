From: Dave Martin <Dave.Martin-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v5 00/30] ARM Scalable Vector Extension (SVE)
Date: Wed, 29 Nov 2017 15:37:29 +0000
Message-ID: <20171129153107.GT12608@e103592.cambridge.arm.com>
References: <1509465082-30427-1-git-send-email-Dave.Martin@arm.com>
 <877eu9dt3n.fsf@linaro.org>
 <20171129152140.GD10650@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171129152140.GD10650-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Szabolcs Nagy <Szabolcs.Nagy-5wv7dgnIgG8@public.gmane.org>, "tokamoto-+CUm20s59erQFUHtdCDX3A@public.gmane.org" <tokamoto-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, "kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org" <kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org>, "libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org" <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>, "linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alan Hayward <Alan.Hayward-5wv7dgnIgG8@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <Mark.Rutland-5wv7dgnIgG8@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dmitry Safonov <dsafonov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, "H . J . Lu" <hjl.tools-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, H. Peter Anv
List-Id: linux-api@vger.kernel.org

On Wed, Nov 29, 2017 at 03:21:40PM +0000, Will Deacon wrote:
> On Wed, Nov 29, 2017 at 03:04:12PM +0000, Alex Bennée wrote:
> > 
> > Dave Martin <Dave.Martin-5wv7dgnIgG8@public.gmane.org> writes:
> > 
> > > This series implements Linux kernel support for the ARM Scalable Vector
> > > Extension (SVE). [1]  It supersedes the previous v3: see [3] for link
> > > and full cover letter.
> > >
> > > This is a minor update to v4, but does contain a couple of important
> > > fixes.
> > <snip>
> > 
> > I seem to have run into a regression with normal non-SVE sigcontexts
> > while trying to run consecutive RISU runs in the Foundation Model. I'm
> > failing to get repeatable results playing back a previous --master run.
> > It works OK with the default Debian kernel.
> > 
> > What is the current status of the tree? I'd like to try an narrow it
> > down but I seem to recall it was now in a next tree somewhere?
> 
> This is in mainline now, so please give a 4.15-rc1 build a spin. If there's
> a user-visible regression then we need to get to the bottom of it ASAP.
> 
> Will

The other significant change was in v4.13, where the signal frame
parser rework landed.

What upstream version is your known-good Debian kernel based on?

Cheers
---Dave
