From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v2 1/2] capabilities: Ambient capabilities
Date: Mon, 18 May 2015 12:48:43 -0700
Message-ID: <CALCETrXKRt9MJQEZc=EEGMFB_vwKDQbZ7ReMNqE-5tRTxxJu2Q@mail.gmail.com>
References: <cover.1431671529.git.luto@kernel.org> <cc4749638a21079cce12f9f30c806170558e56e5.1431671529.git.luto@kernel.org>
 <alpine.DEB.2.11.1505150916330.20103@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.11.1505150916330.20103@gentwo.org>
Sender: linux-security-module-owner@vger.kernel.org
To: Christoph Lameter <cl@linux.com>
Cc: Andy Lutomirski <luto@kernel.org>, Serge Hallyn <serge.hallyn@ubuntu.com>, Andrew Morton <akpm@linuxfoundation.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Ted Ts'o <tytso@mit.edu>, "Andrew G. Morgan" <morgan@kernel.org>, Linux API <linux-api@vger.kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-security-module <linux-security-module@vger.kernel.org>, Aaron Jones <aaronmdjones@gmail.com>, Serge Hallyn <serge.hallyn@canonical.com>, LKML <linux-kernel@vger.kernel.org>, Markku Savela <msa@moth.iki.fi>, Kees Cook <keescook@chromium.org>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

On Fri, May 15, 2015 at 7:19 AM, Christoph Lameter <cl@linux.com> wrote:
> On Thu, 14 May 2015, Andy Lutomirski wrote:
>
>> Cc: Christoph Lameter <cl@linux.com>
>
> This is partially my code it seems. So there should be a
>
> Signed-off-by: Christoph Lameter <cl@linux.com>
>
> here.
>
> Could you provide an example to demonstrate how it is to be used?
> Something similar to what I had in my patch?
>

Do you mean something like:

setpriv --ambient-caps=+net_bind_service --inh-haps=+net_bind_service
--euid=500 --ruid=500 bash

--Andy


-- 
Andy Lutomirski
AMA Capital Management, LLC
