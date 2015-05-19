From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v2 1/2] capabilities: Ambient capabilities
Date: Tue, 19 May 2015 10:37:26 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1505191036490.28005@gentwo.org>
References: <cover.1431671529.git.luto@kernel.org> <cc4749638a21079cce12f9f30c806170558e56e5.1431671529.git.luto@kernel.org> <alpine.DEB.2.11.1505150916330.20103@gentwo.org> <CALCETrXKRt9MJQEZc=EEGMFB_vwKDQbZ7ReMNqE-5tRTxxJu2Q@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CALCETrXKRt9MJQEZc=EEGMFB_vwKDQbZ7ReMNqE-5tRTxxJu2Q@mail.gmail.com>
Sender: linux-security-module-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andy Lutomirski <luto@kernel.org>, Serge Hallyn <serge.hallyn@ubuntu.com>, Andrew Morton <akpm@linuxfoundation.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Ted Ts'o <tytso@mit.edu>, "Andrew G. Morgan" <morgan@kernel.org>, Linux API <linux-api@vger.kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-security-module <linux-security-module@vger.kernel.org>, Aaron Jones <aaronmdjones@gmail.com>, Serge Hallyn <serge.hallyn@canonical.com>, LKML <linux-kernel@vger.kernel.org>, Markku Savela <msa@moth.iki.fi>, Kees Cook <keescook@chromium.org>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

On Mon, 18 May 2015, Andy Lutomirski wrote:

> > Could you provide an example to demonstrate how it is to be used?
> > Something similar to what I had in my patch?
> >
>
> Do you mean something like:
>
> setpriv --ambient-caps=+net_bind_service --inh-haps=+net_bind_service
> --euid=500 --ruid=500 bash

Ok that means we also depend on a tool upgrade.

