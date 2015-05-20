From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v2 0/2] capabilities: Ambient capabilities
Date: Wed, 20 May 2015 12:47:09 -0700
Message-ID: <CALCETrVrmEF-=SSZpWCzb0y6tAu5E6scDYjv6sPsLASWUsBW9g@mail.gmail.com>
References: <cover.1431671529.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <cover.1431671529.git.luto@kernel.org>
Sender: linux-security-module-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, Andrew Morton <akpm@linuxfoundation.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Ted Ts'o <tytso@mit.edu>, "Andrew G. Morgan" <morgan@kernel.org>, Linux API <linux-api@vger.kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-security-module <linux-security-module@vger.kernel.org>, Aaron Jones <aaronmdjones@gmail.com>, Serge Hallyn <serge.hallyn@canonical.com>, LKML <linux-kernel@vger.kernel.org>, Markku Savela <msa@moth.iki.fi>, Kees Cook <keescook@chromium.org>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

On Thu, May 14, 2015 at 11:39 PM, Andy Lutomirski <luto@kernel.org> wrote:
> This adds ambient capabilities.  See the individual patch changelogs
> for details.
>
> Preliminary userspace code is here:
>
> https://git.kernel.org/cgit/linux/kernel/git/luto/util-linux-playground.git/commit/?h=cap_ambient&id=7f5afbd175d2
>
> I'll follow up with a rough draft of a man-pages patch.

Just as a note: I'm going to hold off on v3 until Kees and/or Serge
can take a look, since so far the only changes I want to make to the
kernel part are some comment cleanups and a possible rearrangement of
the pE' stuff that will provably have no effect.

--Andy

>
> Changes from v1:
>  - Lots of cleanups to the ambient cap code.
>  - The securebit is new.
>
> Andy Lutomirski (2):
>   capabilities: Ambient capabilities
>   capabilities: Add a securebit to disable PR_CAP_AMBIENT_RAISE
>
>  fs/proc/array.c                 |  5 ++-
>  include/linux/cred.h            |  8 ++++
>  include/uapi/linux/prctl.h      |  6 +++
>  include/uapi/linux/securebits.h | 11 +++++-
>  kernel/user_namespace.c         |  1 +
>  security/commoncap.c            | 88 ++++++++++++++++++++++++++++++++++++-----
>  security/keys/process_keys.c    |  1 +
>  7 files changed, 108 insertions(+), 12 deletions(-)
>
> --
> 2.1.0
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
