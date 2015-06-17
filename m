From: Leon Romanovsky <leon@leon.nu>
Subject: Re: [RFC v3 4/4] shmem: Add support for generic FS events
Date: Wed, 17 Jun 2015 09:08:41 +0300
Message-ID: <CALq1K=L-DWP5avgXtc0p5=D_M8tXm+Y45DphP7G9QBYo-5sXFA@mail.gmail.com>
References: <1434460173-18427-1-git-send-email-b.michalska@samsung.com> <1434460173-18427-5-git-send-email-b.michalska@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1434460173-18427-5-git-send-email-b.michalska@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Beata Michalska <b.michalska@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux-FSDevel <linux-fsdevel@vger.kernel.org>, linux-api@vger.kernel.org, Greg Kroah <greg@kroah.com>, jack@suse.cz, tytso@mit.edu, adilger.kernel@dilger.ca, Hugh Dickins <hughd@google.com>, lczerner@redhat.com, hch@infradead.org, linux-ext4@vger.kernel.org, Linux-MM <linux-mm@kvack.org>, kyungmin.park@samsung.com, kmpark@infradead.org
List-Id: linux-api@vger.kernel.org

>         }
> -       if (error == -ENOSPC && !once++) {
> +       if (error == -ENOSPC) {
> +               if (!once++) {
>                 info = SHMEM_I(inode);
>                 spin_lock(&info->lock);
>                 shmem_recalc_inode(inode);
>                 spin_unlock(&info->lock);
>                 goto repeat;
> +               } else {
> +                       fs_event_notify(inode->i_sb, FS_WARN_ENOSPC);
> +               }
>         }

Very minor remark, please fix indentation.
