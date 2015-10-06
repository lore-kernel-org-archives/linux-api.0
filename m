From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2] falloc: expose ioctl numbers into uapi
Date: Tue, 06 Oct 2015 10:40:04 +0200
Message-ID: <11363149.diTrmkXsfH@wuerfel>
References: <1444056611-7513-3-git-send-email-gabriel@lse.epita.fr> <1444070673-15836-1-git-send-email-gabriel@lse.epita.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444070673-15836-1-git-send-email-gabriel@lse.epita.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Gabriel Laskar <gabriel@lse.epita.fr>
Cc: Dave Chinner <dchinner@redhat.com>, Ashish Sangwan <a.sangwan@samsung.com>, Namjae Jeon <namjae.jeon@samsung.com>, open list <linux-kernel@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-api@vger.kernel.org

On Monday 05 October 2015 20:44:30 Gabriel Laskar wrote:
> Signed-off-by: Gabriel Laskar <gabriel@lse.epita.fr>
> 

Did you see my 'Acked-by' reply? When you a reply like that,
you should normally add that tag below your 'Signed-off-by'
so it doesn't get lost.

Other than that, I think you should write a changelog text above
about how you discovered it and why it should be done like this.

	Arnd
