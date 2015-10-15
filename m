From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] HID: roccat: Deprecating most Roccat sysfs attributes
Date: Thu, 15 Oct 2015 11:49:44 -0700
Message-ID: <20151015184944.GA1226@kroah.com>
References: <1444921209.2900.17.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1444921209.2900.17.camel-/ZsuMndpQpv+LLWKTYdlgUWBcfzl8p5a/AviwAImx+Y@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Cc: jkosina-AlSwsSmVLrQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Oct 15, 2015 at 05:00:09PM +0200, Stefan Achatz wrote:
> Deprecates all Roccat sysfs attributes except the ones for the old Kone by moving
> abi descriptions from testing to obsolete.
> For most devices everything can be done using the hidraw ioctls HIDIOCGFEATURE
> and HIDIOCSFEATURE, so I would suggest future removal of device specific drivers.
> The userspace tools don't use these attributes for a year now.
> The first Kone is not fully HID-compliant and will still need a module.
> 
> Signed-off-by: Stefan Achatz <erazor_de-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
> ---
>  .../ABI/obsolete/sysfs-driver-hid-roccat-arvo      |  53 ++++++
>  .../ABI/obsolete/sysfs-driver-hid-roccat-isku      | 153 ++++++++++++++++++
>  .../ABI/obsolete/sysfs-driver-hid-roccat-koneplus  |  99 +++++++++++-
>  .../ABI/obsolete/sysfs-driver-hid-roccat-konepure  | 105 ++++++++++++
>  .../ABI/obsolete/sysfs-driver-hid-roccat-kovaplus  |  50 ++++++
>  .../ABI/obsolete/sysfs-driver-hid-roccat-lua       |   7 +
>  .../ABI/obsolete/sysfs-driver-hid-roccat-pyra      |  50 ++++++
>  .../ABI/obsolete/sysfs-driver-hid-roccat-ryos      | 178 +++++++++++++++++++++
>  .../ABI/obsolete/sysfs-driver-hid-roccat-savu      |  76 +++++++++
>  .../ABI/testing/sysfs-driver-hid-roccat-arvo       |  53 ------
>  .../ABI/testing/sysfs-driver-hid-roccat-isku       | 153 ------------------
>  .../ABI/testing/sysfs-driver-hid-roccat-koneplus   |  96 -----------
>  .../ABI/testing/sysfs-driver-hid-roccat-konepure   | 105 ------------
>  .../ABI/testing/sysfs-driver-hid-roccat-kovaplus   |  49 ------
>  .../ABI/testing/sysfs-driver-hid-roccat-lua        |   7 -
>  .../ABI/testing/sysfs-driver-hid-roccat-pyra       |  49 ------
>  .../ABI/testing/sysfs-driver-hid-roccat-ryos       | 178 ---------------------
>  .../ABI/testing/sysfs-driver-hid-roccat-savu       |  76 ---------
>  18 files changed, 770 insertions(+), 767 deletions(-)
>  create mode 100644 Documentation/ABI/obsolete/sysfs-driver-hid-roccat-arvo
>  create mode 100644 Documentation/ABI/obsolete/sysfs-driver-hid-roccat-isku
>  create mode 100644 Documentation/ABI/obsolete/sysfs-driver-hid-roccat-konepure
>  create mode 100644 Documentation/ABI/obsolete/sysfs-driver-hid-roccat-lua
>  create mode 100644 Documentation/ABI/obsolete/sysfs-driver-hid-roccat-ryos
>  create mode 100644 Documentation/ABI/obsolete/sysfs-driver-hid-roccat-savu
>  delete mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-arvo
>  delete mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-isku
>  delete mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus
>  delete mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-konepure
>  delete mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-kovaplus
>  delete mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-lua
>  delete mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-pyra
>  delete mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-ryos
>  delete mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-savu

If you make your patch with 'git format-patch -M' we can see the files
being moved much easier than deleting and adding the files.

thanks,

greg k-h
