From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 2/2 V2] man2: New page documenting filesystem get/set
 label ioctls
Date: Thu, 10 May 2018 12:35:53 -0500
Message-ID: <2c75e14c-c93d-52bc-f13f-9f358889267e@redhat.com>
References: <d2979d75-5e45-b145-9ca5-2c315d8ead9c@redhat.com>
 <708b8e2a-2bc2-df38-ec9c-c605203052b5@sandeen.net>
 <7d74cc3b-52cc-be60-0a69-1a5ee1499f47@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <7d74cc3b-52cc-be60-0a69-1a5ee1499f47@sandeen.net>
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
To: Eric Sandeen <sandeen@sandeen.net>, fsdevel <linux-fsdevel@vger.kernel.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On 5/10/18 12:29 PM, Eric Sandeen wrote:
> This documents the proposed new vfs-level ioctls which can
> get or set a mounted filesytem's label.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: make primary file ioctl_getfslabel, link ioctl_setfslabel to it
>     note that getfslabel requires CAP_SYS_ADMIN

*sigh* that should say "setfslabel" - man page is correct, patch changelog
is not.

-Eric
