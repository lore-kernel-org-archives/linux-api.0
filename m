From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH RFC v2 00/12] socket sendmsg MSG_ZEROCOPY
Date: Tue, 28 Feb 2017 13:47:56 -0800
Message-ID: <1488318476.9415.270.camel@edumazet-glaptop3.roam.corp.google.com>
References: <20170222163901.90834-1-willemdebruijn.kernel@gmail.com>
         <CAHO5Pa1QdQTyEFVAc_E+y3GkYhXM2=z6UXSeoH79ybFiBxs7ag@mail.gmail.com>
         <CALCETrU3tohXaoOTMi8J4FdTggGhvauHt12KyLFV=Q0FjiDNbg@mail.gmail.com>
         <CAF=yD-K_0zO3pMeXf-UKGTsD4sNOdyN9KJkUb5MnCO_J5pisrA@mail.gmail.com>
         <CALCETrUgOpcNO6L3eabAr3P8p86PGYT7BfCt9mcNTu6TNfP7Dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CALCETrUgOpcNO6L3eabAr3P8p86PGYT7BfCt9mcNTu6TNfP7Dw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>, netdev <netdev@vger.kernel.org>, Willem de Bruijn <willemb@google.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, 2017-02-28 at 13:09 -0800, Andy Lutomirski wrote:

> Does this mean that a user program that does a zerocopy send can cause
> a retransmitted segment to contain different data than the original
> segment?  If so, is that okay?

Same remark applies to sendfile() already, or other zero copy modes
(vmsplice() + splice() )
