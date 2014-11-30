From: Florian Weimer <fw@deneb.enyo.de>
Subject: Re: kdbus: add documentation
Date: Sun, 30 Nov 2014 09:56:43 +0100
Message-ID: <8761dxysl0.fsf@mid.deneb.enyo.de>
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org>
	<1416546149-24799-2-git-send-email-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1416546149-24799-2-git-send-email-gregkh@linuxfoundation.org>
	(Greg Kroah-Hartman's message of "Thu, 20 Nov 2014 21:02:17 -0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: arnd@arndb.de, ebiederm@xmission.com, gnomes@lxorguk.ukuu.org.uk, teg@jklm.no, jkosina@suse.cz, luto@amacapital.net, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, daniel@zonque.org, dh.herrmann@gmail.com, tixxdz@opendz.org
List-Id: linux-api@vger.kernel.org

* Greg Kroah-Hartman:

> +The focus of this document is an overview of the low-level, native kernel D-Bus
> +transport called kdbus. Kdbus exposes its functionality via files in a
> +filesystem called 'kdbusfs'. All communication between processes takes place
> +via ioctls on files exposed through the mount point of a kdbusfs. The default
> +mount point of kdbusfs is /sys/fs/kdbus.

Does this mean the bus does not enforce the correctness of the D-Bus
introspection metadata?  That's really unfortunate.  Classic D-Bus
does not do this, either, and combined with the variety of approaches
used to implement D-Bus endpoints, it makes it really difficult to
figure out what D-Bus services, exactly, a process provides.
