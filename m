From: Rishikesh <risrajak@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/80] Kernel based checkpoint/restart [v18]
Date: Thu, 24 Sep 2009 23:50:58 +0530
Message-ID: <4ABBB88A.5000200@linux.vnet.ibm.com>
References: <1253749920-18673-1-git-send-email-orenl@librato.com> <4ABB6EB6.2040204@linux.vnet.ibm.com> <878wg41f65.fsf@caffeine.danplanet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <878wg41f65.fsf@caffeine.danplanet.com>
Sender: owner-linux-mm@kvack.org
To: Dan Smith <danms@us.ibm.com>
Cc: Oren Laadan <orenl@librato.com>, linux-mm@kvack.org, linux-api@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Dan Smith wrote:
> R> I am getting following build error while compiling linux-cr kernel.
>
> With CONFIG_CHECKPOINT=3Dn, right?
>
> R> 76569 net/unix/af_unix.c:528: error: =E2=80=98unix_collect=E2=80=99 =
undeclared here (not=20
> R> in a function)
>
> Try the patch below.
>  =20

Yes attached patch solves the prob. Thanks Dan.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
