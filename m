From: "Dr. Werner Fink" <werner-l3A5Bk7waGM@public.gmane.org>
Subject: Inode for netlinks in /proc/net/netlink?
Date: Tue, 27 Jan 2009 15:41:56 +0100
Message-ID: <20090127144156.GA30646@boole.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi,

currently (2.6.27) there seems to be no Inode informations about
the existing netlinks, only the pid of the process who has opened
such a netlink is seen.  Nevertheless, the file descriptor is
passed over to the child of the creator, e.g. after a fork for
a user space daemon like udevd.

Is there any other way to determine which socket found in dir
/proc/<pid>/fd/ is a netlink and also to determine which type
of netlink it is?  The lsof utility reports

     can't identify protocol

for such netlinks.


       Werner

-- 
  "Having a smoking section in a restaurant is like having
          a peeing section in a swimming pool." -- Edward Burr
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
