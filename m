From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v2 1/2] capabilities: Ambient capabilities
Date: Tue, 19 May 2015 13:23:50 -0700
Message-ID: <CALCETrU3jbtb6MqKHSwo=5PLoDi09HVdb=254kK++ezpCfcK6g@mail.gmail.com>
References: <cover.1431671529.git.luto@kernel.org> <cc4749638a21079cce12f9f30c806170558e56e5.1431671529.git.luto@kernel.org>
 <alpine.DEB.2.11.1505150916330.20103@gentwo.org> <CALCETrXKRt9MJQEZc=EEGMFB_vwKDQbZ7ReMNqE-5tRTxxJu2Q@mail.gmail.com>
 <alpine.DEB.2.11.1505191036490.28005@gentwo.org> <CALCETrV1+3ZuL0MkqQaRoQ8r2V=EcQQEodOdCdP0p-BK1PixGg@mail.gmail.com>
 <alpine.DEB.2.11.1505191502570.31044@gentwo.org> <CALCETrW6DndOnC5ego+R5rwjoXeFo04cSO4Z2qZnhiJpEPBE=Q@mail.gmail.com>
 <555B9B79.9080806@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <555B9B79.9080806@gmail.com>
Sender: linux-security-module-owner@vger.kernel.org
To: Aaron Jones <aaronmdjones@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Ted Ts'o <tytso@mit.edu>, "Andrew G. Morgan" <morgan@kernel.org>, Andrew Morton <akpm@linuxfoundation.org>, Serge Hallyn <serge.hallyn@ubuntu.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Linux API <linux-api@vger.kernel.org>, Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-security-module <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Serge Hallyn <serge.hallyn@canonical.com>, Markku Savela <msa@moth.iki.fi>, Kees Cook <keescook@chromium.org>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

On Tue, May 19, 2015 at 1:22 PM, Aaron Jones <aaronmdjones@gmail.com> wrote:
> On 19/05/15 20:07, Andy Lutomirski wrote:> It's in the cover letter,
> rather vaguely.  I think I want to change
>> the setpriv syntax a bit before sending it upstream, though -- it's
>> sucks that you have to duplicate the option.
>>
>> Perhaps the ambient-caps option should implicitly raise inheritable
>> caps if they're not already raised.  Or maybe the absence of an
>> inh-caps rule should cause any requested ambient caps to be made
>> inheritable as well.
>>
>> --Andy
>
> I propose an additional --ambient-inh option to copy everything from
> --inh-caps to the ambient set. Explicit is better than implicit.

Seems reasonable.  I'll do something like that for v2.1.

--Andy
