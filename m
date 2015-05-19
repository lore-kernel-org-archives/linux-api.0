From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v2 1/2] capabilities: Ambient capabilities
Date: Tue, 19 May 2015 10:20:02 -0700
Message-ID: <CALCETrV1+3ZuL0MkqQaRoQ8r2V=EcQQEodOdCdP0p-BK1PixGg@mail.gmail.com>
References: <cover.1431671529.git.luto@kernel.org> <cc4749638a21079cce12f9f30c806170558e56e5.1431671529.git.luto@kernel.org>
 <alpine.DEB.2.11.1505150916330.20103@gentwo.org> <CALCETrXKRt9MJQEZc=EEGMFB_vwKDQbZ7ReMNqE-5tRTxxJu2Q@mail.gmail.com>
 <alpine.DEB.2.11.1505191036490.28005@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.11.1505191036490.28005@gentwo.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Lameter <cl@linux.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Ted Ts'o <tytso@mit.edu>, "Andrew G. Morgan" <morgan@kernel.org>, Andrew Morton <akpm@linuxfoundation.org>, Serge Hallyn <serge.hallyn@ubuntu.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Linux API <linux-api@vger.kernel.org>, Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-security-module <linux-security-module@vger.kernel.org>, Aaron Jones <aaronmdjones@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Serge Hallyn <serge.hallyn@canonical.com>, Markku Savela <msa@moth.iki.fi>, Kees Cook <keescook@chromium.org>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

On May 19, 2015 8:37 AM, "Christoph Lameter" <cl@linux.com> wrote:
>
> On Mon, 18 May 2015, Andy Lutomirski wrote:
>
> > > Could you provide an example to demonstrate how it is to be used?
> > > Something similar to what I had in my patch?
> > >
> >
> > Do you mean something like:
> >
> > setpriv --ambient-caps=+net_bind_service --inh-haps=+net_bind_service
> > --euid=500 --ruid=500 bash
>
> Ok that means we also depend on a tool upgrade.
>

I think this is unavoidable, unless we want to change the semantics of
inheritable caps, and that would open a giant can of worms.

--Andy
