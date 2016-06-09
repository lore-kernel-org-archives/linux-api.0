From: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH v6 3/6] crypto: AF_ALG -- add asymmetric cipher interface
Date: Thu, 09 Jun 2016 20:36:29 +0200
Message-ID: <3072103.TY3EQcF1Bz@tauon.atsec.com>
References: <20160515041645.15888.94903.stgit@tstruk-mobl1> <1499283.NSekfIF0FQ@tauon.atsec.com> <alpine.OSX.2.20.1606091126420.21471@mjmartin-mac01.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.OSX.2.20.1606091126420.21471-zaFMaa3cLiZe6KzckbbZvYT4S9po1h25@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mat Martineau <mathew.j.martineau-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org
List-Id: linux-api@vger.kernel.org

Am Donnerstag, 9. Juni 2016, 11:27:13 schrieb Mat Martineau:

Hi Mat, Tadeusz,

> On Thu, 9 Jun 2016, Stephan Mueller wrote:
> > Am Donnerstag, 9. Juni 2016, 11:18:04 schrieb Mat Martineau:
> > 
> > Hi Mat,
> > 
> >>> Or is your concern that the user space interface restricts things too
> >>> much
> >>> and thus prevents a valid use case?
> >> 
> >> The latter - my primary concern is the constraint this places on
> >> userspace
> >> by forcing larger buffer sizes than might be necessary for the operation.
> >> struct akcipher_request has separate members for src_len and dst_len, and
> >> dst_len is documented as needing "to be at least as big as the expected
> >> result depending on the operation". Not the maximum result, the expected
> >> result. It's also documented that the cipher will generate an error if
> >> dst_len is insufficient and update the value with the required size.
> >> 
> >> I'm updating some userspace TLS code that worked with an earlier,
> >> unmerged
> >> patch set for AF_ALG akcipher (from last year). The read calls with
> >> shorter buffers were the main porting problem.
> > 
> > I see -- are you proposing to drop that check entirely?
> 
> Yes.

Ok, after checking the code again, I think that dropping that sanity check 
should be ok given that this length is part of the akcipher API.

Tadeusz, as you are currently managing that patch set, would you re-spin it 
with the following check removed?

+     if (usedpages < akcipher_calcsize(ctx)) {
+             err = -EMSGSIZE;
+             goto unlock;
+     }


Ciao
Stephan
