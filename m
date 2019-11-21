From: "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Subject: Re: [RESEND RFC PATCH 0/1] CAP_SYS_NICE inside user namespace
Date: Thu, 21 Nov 2019 19:33:23 +0100
Message-ID: <c7949242-385f-3256-b290-87640acd0577@metux.net>
References: <1574096478-11520-1-git-send-email-prakash.sangappa@oracle.com>
 <CAG48ez3HfUx2aRvqR_bWnGoTshrHnUzxUNt7K6Sv7cqtPDWaWw@mail.gmail.com>
 <9a63f7ae-562e-67a6-8f40-050c58c08933@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9a63f7ae-562e-67a6-8f40-050c58c08933@oracle.com>
Content-Language: tl
Sender: linux-kernel-owner@vger.kernel.org
To: Prakash Sangappa <prakash.sangappa@oracle.com>, Jann Horn <jannh@google.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, "Serge E. Hallyn" <serge@hallyn.com>, Christian Brauner <christian@brauner.io>
List-Id: linux-api@vger.kernel.org

On 18.11.19 21:34, Prakash Sangappa wrote:

> It is more the latter. Admin should be able to explicitly decide that
> container A
> workload is to be given priority over other containers.

I guess, you're talking about the host's admin, correct ?

Shouldn't this already be possibly by tweaking the container's cgroups ?


--mtx

-- 
Dringender Hinweis: aufgrund existenzieller Bedrohung durch "Emotet"
sollten Sie *niemals* MS-Office-Dokumente via E-Mail annehmen/öffenen,
selbst wenn diese von vermeintlich vertrauenswürdigen Absendern zu
stammen scheinen. Andernfalls droht Totalschaden.
---
Hinweis: unverschlüsselte E-Mails können leicht abgehört und manipuliert
werden ! Für eine vertrauliche Kommunikation senden Sie bitte ihren
GPG/PGP-Schlüssel zu.
---
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
