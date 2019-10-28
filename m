From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH RFC] fs/fcntl: add fcntl F_GET_RSS
Date: Mon, 28 Oct 2019 13:27:32 +0100
Message-ID: <CAHk-=wiCDPd1ivoU5BJBMSt5cmKnX0XFWiinfegyknfoipif0g@mail.gmail.com>
References: <157225848971.557.16257813537984792761.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <157225848971.557.16257813537984792761.stgit@buzz>
Sender: linux-kernel-owner@vger.kernel.org
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Michal Hocko <mhocko@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 28, 2019 at 11:28 AM Konstantin Khlebnikov
<khlebnikov@yandex-team.ru> wrote:
>
> This implements fcntl() for getting amount of resident memory in cache.
> Kernel already maintains counter for each inode, this patch just exposes
> it into userspace. Returned size is in kilobytes like values in procfs.

This doesn't actually explain why anybody would want it, and what the
usage scenario is.

             Linus
