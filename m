From: James Morris <james.l.morris@oracle.com>
Subject: Re: [PATCHv3 0/2] capability controlled user-namespaces
Date: Mon, 8 Jan 2018 20:51:20 +1100 (AEDT)
Message-ID: <alpine.LFD.2.20.1801082040180.12014@localhost>
References: <20171205223052.12687-1-mahesh@bandewar.net> <CAF2d9jit74_VCdD-pEFy3bJo2W1-0cDo0BOJC5beJiy8yFPCWg@mail.gmail.com> <alpine.LFD.2.20.1712301931360.24310@localhost> <CAF2d9jiPYvMN=_guoZHyTA5FmMgaJb5mtxroi5D9NvcNrHc5gg@mail.gmail.com>
 <alpine.LFD.2.20.1801081131190.8436@localhost> <20180108062452.GA21717@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <kernel-hardening-return-11086-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20180108062452.GA21717@mail.hallyn.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: =?UTF-8?Q?Mahesh_Bandewar_=28=E0=A4=AE=E0=A4=B9=E0=A5=87=E0=A4=B6_=E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=A4=B0=29?= <maheshb@google.com>, LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>, Kernel-hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Eric W . Biederman" <ebiederm@xmission.com>, Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>, Mahesh Bandewar <mahesh@bandewar.net>
List-Id: linux-api@vger.kernel.org

On Mon, 8 Jan 2018, Serge E. Hallyn wrote:

> > Also, why do we need the concept of a controlled user-ns at all, if the 
> > default whitelist maintains existing behavior?
> 
> In past discussions two uses have been brought up:
> 
> 1. if an 0-day is discovered which is exacerbated by a specific
> privilege in user namespaces, that privilege could be turned off until a
> reboot with a fixed kernel is scheduled, without fully disabling all
> containers.
> 
> 2. some systems may be specifically designed to run software which
> only requires a few capabilities in a userns.  In that case all others
> could be disabled.
> 

I meant in terms of "marking" a user ns as "controlled" type -- it's 
unnecessary jargon from an end user point of view.

This may happen internally but don't make it a special case with a 
different name and don't bother users with internal concepts: simply 
implement capability whitelists with the default having equivalent 
behavior of everything allowed.  Then, document the semantics of the 
whitelist in terms of inheritance etc., as a feature of user namespaces, 
not as a "type" of user namespace.


- James
-- 
James Morris
<james.l.morris@oracle.com>
