From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] capabilities: Ambient capability set V1
Date: Mon, 23 Feb 2015 07:44:48 -0800
Message-ID: <CALCETrWJCcBBGGp21C4cdtiU79K-P3t+6rFJUWcXcLR1jqrrFQ@mail.gmail.com>
References: <alpine.DEB.2.11.1502051554500.4876@gentwo.org> <alpine.DEB.2.11.1502230856400.21238@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.11.1502230856400.21238@gentwo.org>
Sender: linux-security-module-owner@vger.kernel.org
To: Christoph Lameter <cl@linux.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>, Aaron Jones <aaronmdjones@gmail.com>, Ted Ts'o <tytso@mit.edu>, LSM List <linux-security-module@vger.kernel.org>, Andrew Morton <akpm@linuxfoundation.org>, "Andrew G. Morgan" <morgan@kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Markku Savela <msa@moth.iki.fi>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

On Mon, Feb 23, 2015 at 6:58 AM, Christoph Lameter <cl@linux.com> wrote:
> Ok 4.0-rc1 is out and this patch has been sitting here for a couple of
> weeks without comment after an intensive discussion about the RFCs.
>
> Since there were no objections: Is there any chance to get this into -next
> somehow?
>

At the very least, I think it needs to define and implement what
happens when a cap is added to ambient and then dropped from
permitted. We also may need LSM_UNSAFE_something to clear the ambient
set to avoid a major security issue.

I'd like to discuss (in the hallway if nothing else) at LSF/MM with
whatever other interested people will be there.

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
