From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 00/12] Add kdbus implementation
Date: Thu, 30 Oct 2014 09:17:52 -0700
Message-ID: <20141030161752.GB21989@kroah.com>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <4382138.U2ODUIQ55c@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4382138.U2ODUIQ55c@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, john.stultz@linaro.org, tj@kernel.org, marcel@holtmann.org, desrt@desrt.ca, hadess@hadess.net, dh.herrmann@gmail.com, tixxdz@opendz.org, simon.mcvittie@collabora.co.uk, daniel@zonque.org, alban.crequy@collabora.co.uk, javier.martinez@collabora.co.uk, teg@jklm.no
List-Id: linux-api@vger.kernel.org

On Thu, Oct 30, 2014 at 09:33:56AM +0100, Arnd Bergmann wrote:
> On Wednesday 29 October 2014 15:00:44 Greg Kroah-Hartman wrote:
> >  drivers/misc/Kconfig                             |    1 +
> >  drivers/misc/Makefile                            |    1 +
> >  drivers/misc/kdbus/Kconfig                       |   11 +
> >  drivers/misc/kdbus/Makefile                      |   19 +
> >  drivers/misc/kdbus/bus.c                         |  450 ++++++
> >  drivers/misc/kdbus/bus.h                         |  107 ++
> >  drivers/misc/kdbus/connection.c                  | 1751 +++++++++++++++++++++
> >  drivers/misc/kdbus/connection.h                  |  177 +++
> >  drivers/misc/kdbus/domain.c                      |  477 ++++++
> > 
> 
> One very high-level common:
> 
> Since this is going to be a very commonly used IPC mechanism, I don't
> like the idea of stuffing it into drivers/misc.
> 
> How about putting it into drivers/kdbus or ipc/kdbus instead?

ipc/kdbus seems good to me.  I didn't want to "pollute" drivers/ with
any new subdirectories, it seems to grow fast enough as it is...

greg k-h
