
function [] = Hubal_converter(DICOM_klasoru, Niftiler_nereye)
% Kullaným þekilleri:
% Eðer dicom dosyalarýnýn bulunduðu klasör ve hedef klasör yolu biliniyorsa
% Hubal_converter(DICOM_klasoru, Niftiler_nereye);
% Eðer arayüz ile klasörlerin yerleri belirtilecekse
% Hubal_converter;
%
% Dicom klasöründeki tüm denekler dönüþtürülecek
% Eðer deðiþkenleri girmezsen arayüzden seçersin.
% Rar dosyalarýný görmez o yüzden dönüþtürmeyeceklerin rar kalabilir.
% mcverter.exe konumunu DCMconverter deðiþkenine yazmalýsýn.
% 24.10.2018
% AliB

DCMconverter = 'D:\mri_tools\dicom_converter\mcverter.exe';
parametreler = ' -f nifti -q -j -x -u --fnformat=%%PI_%%SN_%%PR ';
% -f: Output format: fsl, spm, meta, nifti, analyze, or bv.
% -q: quiet mode
% -j: Save each subject to a separate directory
% -x: Save each series to a separate directory
% -u: Use patient id instead of patient name for output file
% %%PI_%%SN_%%PR: PatientId_SeriesNumber_ProtocolName

if nargin ~= 2
    DICOM_klasoru = uigetdir('','DICOM Klasörünü seçiniz');
    Niftiler_nereye = uigetdir('','Nifti dosyalarýnýn kaydedileceði klasörü seçiniz');
end

if ~isequal(DICOM_klasoru,0) && ~isequal(Niftiler_nereye,0)
    fprintf('DICOM klasörü ve Nifti klasörü seçildi\n');
    tum_icerik = dir(DICOM_klasoru);
    tum_icerik(ismember( {tum_icerik.name}, {'.', '..'})) = []; %silinenler
    alt_klasorler = [tum_icerik.isdir];
    subj_dirs =  tum_icerik(alt_klasorler);
    if isempty(subj_dirs)
        fprintf('DICOM klasörü içinde denek klasörleri bulunamadý.\n');
    else
        for subj_dirs_ind = 1 : length(subj_dirs)
            DICOMsubjdir = fullfile(DICOM_klasoru, subj_dirs(subj_dirs_ind).name);
            sonuc = system([DCMconverter, ' -o ', Niftiler_nereye, parametreler, DICOMsubjdir]);
            if ~sonuc
                fprintf('%d. denek klasörünün dönüþtürme iþlemi tamamlandý\n',subj_dirs_ind);
            else
                fprintf('%s\nKlasördeki DICOM dosyalarý Nifti''ye dönüþtürülemedi!\n',subj_dirs(subj_dirs_ind).name);
            end
        end
    end
else
    fprintf('DICOM klasörü ve/veya Nifti klasörü seçilmedi.\n');
end
